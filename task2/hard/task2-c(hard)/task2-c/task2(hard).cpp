#include <stdio.h>
#include <cmath>

extern "C" void _ZL5checkb(bool flag);

namespace var6 {
	struct S {
		unsigned long long field0;
		unsigned long long field1;
	};


	class C {
	public:

		bool check(const S& s) const {
			unsigned int r8 = 0;
			unsigned int rdx = (unsigned int)s.field0;
			unsigned int r9 = rdx;

			rdx = rdx >> 1;
			int ecx = 63;

			while (ecx--) {
				unsigned int eax = r9 ^ rdx;
				rdx = rdx >> 1;
				r8 += eax & 1;
				r9 = r9 >> 1;
			}

			unsigned char first_byte = *((unsigned char*)this);
			if (first_byte > r8) return false;

			int Y;
			double X = *(double*)&s.field1;
			frexp(X, &Y);

			short word2 = *((short*)((unsigned char*)this + 2));
			word2 = -word2;

			return Y >= word2;
		}
	};

	extern "C" void access6(const S& s, const C& c) {
		bool flag = true;

		uintptr_t ptr_val = reinterpret_cast<uintptr_t>(&c);

		// Проверка младшего байта
		if ((ptr_val & 0xFF) == 0) flag = false;

		// Проверка 2-байтового значения
		if (((ptr_val >> 16) & 0xFFFF) == 0) flag = false;

		// Проверка через метод C::check
		if (!c.check(s)) flag = false;

		_ZL5checkb(flag);
	}

}



extern "C" void _ZL5checkb(bool flag) {
	if (!flag) {
		printf("Access Denied\n");
		exit(-1);
	}

	printf("Access Granted\n");

}


int main() {

	var6::S s;
	s.field0 = 0x0000000000000001;
	s.field1 = 0x0000000000000001;

	var6::C c;


	var6::access6(s, c);

	return 0;
}
