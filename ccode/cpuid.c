#include <stdio.h>

char* getPSN(/*char *PSN*/)
{
	int varEAX, varEBX, varECX, varEDX;
	char str[9];
	//PSN = malloc(sizeof(char) * 30);
	char* PSN = malloc(30);
	printf("CCODE:Getting processor serial number.\n");
	//%eax=1 gives most significant 32 bits in eax
	__asm__ __volatile__ ("cpuid": "=a" (varEAX), "=b" (varEBX), "=c" (varECX), "=d" (varEDX) : "a" (1));
	sprintf(str, "%08X", varEAX); //i.e. XXXX-XXXX-xxxx-xxxx-xxxx-xxxx
	sprintf(PSN, "%C%C%C%C-%C%C%C%C", str[0], str[1], str[2], str[3], str[4], str[5], str[6], str[7]);
	//%eax=3 gives least significant 64 bits in edx and ecx [if PN is enabled]
	__asm__ __volatile__ ("cpuid": "=a" (varEAX), "=b" (varEBX), "=c" (varECX), "=d" (varEDX) : "a" (3));
	sprintf(str, "%08X", varEDX); //i.e. xxxx-xxxx-XXXX-XXXX-xxxx-xxxx
	sprintf(PSN, "%s-%C%C%C%C-%C%C%C%C", PSN, str[0], str[1], str[2], str[3], str[4], str[5], str[6], str[7]);
	sprintf(str, "%08X", varECX); //i.e. xxxx-xxxx-xxxx-xxxx-XXXX-XXXX
	sprintf(PSN, "%s-%C%C%C%C-%C%C%C%C", PSN, str[0], str[1], str[2], str[3], str[4], str[5], str[6], str[7]);
	return PSN;
}
