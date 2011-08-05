/*
 *  testInformation.h
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

/*test script settings that need to be set by the user*/

#define HOST_COMPUTER_TITLE @"Home Computer"
#define HOST_COMPUTER_NAME NULL
#define HOST_COMPUTER_PORT_NUMBER 0
#define HOST_COMPUTER_SOCKET_NAME NULL
#define HOST_COMPUTER_FLAGS 0
#define HOST_COMPUTER_PASSWORD @"secret"
#define HOST_COMPUTER_USER @"doug"
#define HOST_COMPUTER_DATABASE @"Loki_Tools"

#define HOST_FALSE_NAME @"www.wrongserver.wrong"
#define HOST_FALSE_PASSWORD @"wrong password"
#define HOST_FALSE_USER @"wrong userName"
#define HOST_FALSE_SOCKET_NAME @"wrong socket"
#define HOST_FALSE_DATABASE @"wrong database"

#define STRING_TO_ESCAPE_CHANGELESS @"WARNING DOCTOR ROBINSON"
#define STRING_TO_ESCAPE @"\"this should be % apple"
#define ESCAPE_STRING_RESULT @"\\\"this should be \% apple"