#include <stdio.h>

#define MAX_SIZE 150

int arr[MAX_SIZE];
int n = 0;

int getNextGap(int gap) {
	gap = (gap * 10) / 13;

	if (gap < 1) return 1;

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

	while (gap > 1 || swapped) {
		gap = getNextGap(gap);

		swapped = false;

		for (int i = 0; i < n - gap; ++i) {
			if (arr[i] > arr[i + gap]) {
				swap(&arr[i], &arr[i + gap]);
				swapped = true;
			}
		}

	}
}


void printArr(int arr[], int n) {

	for (int i = 0; i < n; ++i) {
		printf("%d", arr[i]);
		printf(" ");
	}

	printf("\n");

}


int main() {

	printf("Enter array size from 1 to %d: ", MAX_SIZE);
	scanf("%d", &n);

	printf("Enter %d elements: ", n);
	for (int i = 0; i < n; ++i) {
		scanf("%d", &arr[i]);
	}

	printf("Original array: ");
	printArr(arr, n);

	printf("Sorted array: ");
	combSort(arr, n);
	printArr(arr, n);
}
