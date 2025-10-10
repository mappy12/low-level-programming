#include <stdio.h>

#define MAX_SIZE 150

int arr[MAX_SIZE];
int n = 0;

int getNextGap(int gap) {
	gap *= 10;
	gap /= 13;

	if (gap >= 1) goto gapOk;
	return 1;

gapOk:
	return gap;
}


void swap(int* a, int* b) {
	int temp = *a;
	*a = *b;
	*b = temp;
}


void combSort(int arr[], int n) {
	int gap = n;
	bool swapped = true;
	int i = 0;

mainLoop:
	if (gap > 1) goto combBody;
	if (swapped) goto combBody;
	goto endSort;

combBody:
	gap = getNextGap(gap);
	swapped = 0;

	i = 0;

	goto innerLoop;

innerLoop:
	if (i < n - gap) goto innerLoopBody;
	goto mainLoop;

innerLoopBody:
	if (arr[i] > arr[i + gap]) goto swap;
	goto nextElement;

swap:
	swap(&arr[i], &arr[i + gap]);
	swapped = true;
	goto nextElement;

nextElement:
	++i;
	goto innerLoop;

endSort:
	return;
}


void printArr(int arr[], int n) {
	int i = 0;

loop:
	if (i >= n) goto endPrint;
	goto print;

nextElement:
	++i;
	goto loop;

print:
	printf("%d", arr[i]);
	printf(" ");

	goto nextElement;

endPrint:
	printf("\n");

	return;

}


int main() {
	printf("Enter array size from 1 to %d: ", MAX_SIZE);
	scanf("%d", &n);

	printf("Enter %d elements: ", n);

	int i = 0;

loop:
	if (i >= n) goto afterLoop;
	goto scan;

scan:
	scanf("%d", &arr[i]);
	goto nextElement;

nextElement:
	++i;
	goto loop;

afterLoop:
	printf("Original array: ");
	printArr(arr, n);

	printf("Sorted array: ");
	combSort(arr, n);
	printArr(arr, n);
}