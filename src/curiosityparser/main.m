#include <stdio.h>
#include <math.h>

// Standard CSPICE User Include File
#include "SpiceUsr.h"

/*
 * Local parameters
 */
#define METAKERNEL "curiosity.tm"
#define SPK "./data/spk/msl_surf_rover_tlm_0000_0089_v1.bsp"

#define  FILSIZ         256
#define  MAXIV          1000
#define  WINSIZ         ( 2 * MAXIV )
#define  TIMLEN         51
#define  MAXOBJ         1000
#define MAXLEN 32


#define        ABCORR        "NONE"
#define        FRAME         "IAU_MARS"

/*
 * ET0 represents the date 2000 Jan 1 12:00:00 TDB.
 */
#define        ET0           0.0

/*
 * Use a time step of 1 hour; look up 100 states.
 */
#define        STEP          3600.0
#define        MAXITR        100

#define        OBSERVER      "MSL_LANDING_SITE"
#define        TARGET        "msl"

int main() {
	
	/*
	 * Load Meta Kernel
	 */
	furnsh_c(METAKERNEL);
	
	/*
	 * Local variables
	 */
	SPICEDOUBLE_CELL        ( cover, WINSIZ );
	SPICEINT_CELL           ( ids,   MAXOBJ );
	
	SpiceChar               lsk     [ FILSIZ ];
	SpiceChar               timstr  [ TIMLEN ];
	
	SpiceDouble             b;
	SpiceDouble             e;
	
	SpiceInt                i;
	SpiceInt                j;
	SpiceInt                k;
	SpiceInt                niv;
	SpiceInt                obj;
	SpiceBoolean			found;
	
	SpiceChar objname [MAXLEN];
	
	SpiceDouble    et;
	SpiceDouble    lt;
	SpiceDouble    pos [3];
	
	SpiceDouble x;
	SpiceDouble y;
	SpiceDouble z;
	
	/*
	 * Find the set of objects in the SPK file.
	 */
	spkobj_c(SPK, &ids);
	
	/*
	 * We want to display the coverage for each object. Loop over the contents of the ID code set, find the coverage for each item in the set, and display the coverage.
	 */
	for ( i = card_c(&ids) - 1;  i > card_c(&ids) - 2 ;  i--  ) {
		/*
		 * Find the coverage window for the current object.
		 * Empty the coverage window each time so we don't include data for the previous object.
		 */
		obj  =  SPICE_CELL_ELEM_I( &ids, i );
		
		scard_c  ( 0,        &cover );
		spkcov_c(SPK, obj, &cover);
		
		/*
		 * Get the number of intervals in the coverage window.
		 */
		niv = wncard_c ( &cover );
		
		/*
		 * Get the name of the currentobject
		 */
		bodc2n_c(obj, MAXLEN, objname, &found);
		
		if (found) {
			/*
			 * Display a simple banner.
			 */
			//printf ( "%s\n", "========================================" );
			
			//printf ( "Coverage for object %d\n", obj );
			//printf ( "Object %s", objname );
			
			printf("[\n");
			
			/*
			 * Convert the coverage interval start and stop times to TDB calendar strings.
			 */
			for ( j = 0;  j < niv;  j++  ) {
				/*
				 * Get the endpoints of the jth interval.
				 */
				wnfetd_c ( &cover, j, &b, &e );
				
				/*
				 * Convert the endpoints to TDB calendar format time strings and display them.
				 */
				
				et = b;
				while (et < e - 10*STEP) {
					et = b + k*STEP;
					
					if (et > b) {
						printf(",\n");
					}
					printf("\t{\n");
					
					/*
					printf("Object %s (%d)\n", objname, obj);
					timout_c(b, "YYYY/MM/DD HR:MN:SC.### (TDB) ::TDB", TIMLEN, timstr);
					printf("Start:		%s\n", timstr);
					timout_c(e, "YYYY/MM/DD HR:MN:SC.### (TDB) ::TDB", TIMLEN, timstr);
					printf("Stop:		%s\n", timstr);
					 */
					timout_c(et, "YYYY/MM/DD HR:MN:SC.### (TDB) ::TDB", TIMLEN, timstr);
					printf("\t\t\"date\": \"%s\",\n", timstr);
					
					spkpos_c (objname, et, FRAME, ABCORR, OBSERVER, pos, &lt);
					x = pos[0];
					y = pos[1];
					z = pos[2];
					printf("\t\t\"x\": %20.10f,\n", x);
					printf("\t\t\"y\": %20.10f,\n", y);
					printf("\t\t\"z\": %20.10f,\n", z);
					
					
					printf("\t}");
					k++;
				}
			}
			
			printf("\n]");
		}
	}
	return ( 0 );
}