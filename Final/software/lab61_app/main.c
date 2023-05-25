// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng
#include "system.h"
int main()
{
	int i = 0;
	volatile unsigned int *ls = (unsigned int*)LED_BASE; //make a pointer to access the PIO block
	volatile unsigned int *ap = (unsigned int*) ACCUMULATE_BASE;
	volatile unsigned int *rp = (unsigned int*)RESET_BASE;
	volatile unsigned int *sp = (unsigned int*)SWITCHES_BASE;
	volatile unsigned int sum = 0;
	int pause = 0;

	*ls = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{

		if(*rp == 0){
			sum = 0;
		}
		if(*ap == 0 && pause == 0){
			sum = sum + *sp % 256;
			pause = 1;
		}
		if(*ap == 1){
			pause = 0;
		}
		*ls = sum;

	}



	return 1; //never gets here
}
