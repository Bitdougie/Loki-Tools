/*
 *  xLokiProcedures.c
 *  Loki_Tools
 /*
 Loki Tools a Search engine, data preperation tool that does data mining
 and retail analysis.
 Copyright (C) 2011  Douglas Mason
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.//
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




