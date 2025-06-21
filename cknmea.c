#include <stdio.h>
// Create a checksum of a string on the command line by xor'ing the characters together. 
// The output is in hexidecimal format
//
/*
In Java script:
var checksum = 0;
for(var i = 0; i < stringToCalculateTheChecksumOver.length; i++) {
  checksum = checksum ^ stringToCalculateTheChecksumOver.charCodeAt(i);
}

In C#:
int checksum = 0;
for (inti = 0; i < stringToCalculateTheChecksumOver.length; i++){
checksum ^= Convert.ToByte(sentence[i]);}

In VB.Net:
Dim checksum as Integer = 0
For Each Character As Char In stringToCalculateTheChecksumOver 
          checksum = checksum Xor Convert.ToByte(Character)
Next 
*/


int main(int argc,char *argv[])
{
  char* s;
  unsigned int checksum = 0;
	
	if (argc > 1){
	    s = argv[1];
		for (int i=0;  s[i] != '\0'; i++)
		{
			checksum ^= s[i];
		}
	}
    // printf("<%s>\n",s);
	printf("%02X\n",checksum);
}
