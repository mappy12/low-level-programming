#include <iostream>
#include <cmath>

// Заглушка для функции проверки
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
        long long divisor;        // 64-битное целое (смещение 0)
        float dividend;           // float (смещение 8)
        float expected_result;    // float (смещение 12/0Ch)
    };
}

// Реализация функции access6 - ТОЛЬКО ОДНА ВЕРСИЯ
extern "C" void access6(const var6::S* s, double double_param, int integer_param) {
    // Преобразуем divisor из long long в float
    float divisor_float = static_cast<float>(s->divisor);

    // Выполняем деление: dividend / divisor
    float division_result = s->dividend / divisor_float;

    // Преобразуем expected_result в int и обратно в float
    int temp_int = static_cast<int>(s->expected_result);
    float reconverted = static_cast<float>(temp_int);

    // Первое условие: результат деления должен равняться преобразованному значению
    if (division_result != reconverted) {
        _ZN6mediumL5checkEb(false);
        return;
    }

    // Второе условие: проверяем знаки double_param и integer_param
    bool sign_double = std::signbit(double_param);

    // Преобразуем integer_param в float для проверки знака
    float int_as_float = static_cast<float>(integer_param);
    bool sign_float = std::signbit(int_as_float);

    // Знаки должны быть разные
    _ZN6mediumL5checkEb(sign_double != sign_float);
}

int main() {
    // Тест 1: успешный случай
    var6::S test_data;
    test_data.divisor = 2;           // 64-битное целое
    test_data.dividend = 8.0f;       // float
    test_data.expected_result = 4.0f; // float (должен быть целым числом)

    int integer_param = -5;          // отрицательное целое
    double double_param = 3.14;      // положительное double

    std::cout << "Test 1: ";
    access6(&test_data, double_param, integer_param);

    return 0;
}