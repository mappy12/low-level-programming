#include <iostream>
#include <cmath>

extern "C" void _ZN6mediumL5checkEb(bool result) {
    if (result) {
        std::cout << "Access granted" << std::endl;
    }
    else {
        std::cout << "Access denied" << std::endl;
    }
}

namespace var6 {
    struct S {
        unsigned long long b;
        float a;
        float c;
    };
}

extern "C" void access6(const var6::S* s, double double_arg, int int_arg) {
    float divisor_float = static_cast<float>(s->b);

    float div_res = s->a / divisor_float;

    int float_to_int = static_cast<int>(s->c);
    float reconverted = static_cast<float>(float_to_int);

    if (div_res != reconverted) {
        _ZN6mediumL5checkEb(false);
        return;
    }

    bool double_sign = std::signbit(double_arg);

    float int_to_float = static_cast<float>(int_arg);
    bool float_sign = std::signbit(int_to_float);

    bool second_check = (double_sign != float_sign);
    _ZN6mediumL5checkEb(second_check);

}

int main() {

    var6::S test;
    test.b = 2;           
    test.a = 8.0f;      
    test.c = 4.0f; 

    int int_arg = -5;       
    double double_arg = 1.0;      // положительное double

    access6(&test, double_arg, int_arg);

    return 0;
}
