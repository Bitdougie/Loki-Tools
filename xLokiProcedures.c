/*
 *  xLokiProcedures.c
 *  Loki_Tools
 *
 *  Created by Douglas Mason on 16/02/11.
 *  Copyright 2011 Farrand & Mason Ltd. All rights reserved.
 *
 */

#include "xLokiProcedures.h"

/* 
 Trys ten times to allocate memory
 */

void *
xmalloc(size_t size)
{
	void *memoryBlock;
	
	for (int n = 0; n < 10; n++) {
		memoryBlock = malloc(size);
		
		if (memoryBlock == NULL) {
			fprintf(stderr, "failed to allocate memory");
		}
		else {
			n = 11;
		}
	}
	
	if (memoryBlock == NULL) {
		fprintf(stderr, "Final try to allocate memory failed");
		exit(1);
	}
	
	return memoryBlock;
}




