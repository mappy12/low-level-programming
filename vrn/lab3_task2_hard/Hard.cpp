#include <stdio.h>
#include <stdlib.h>  // для exit

namespace var6 {
    struct S {
        unsigned long long data[2];  // 16 байт
    };

    class C {
    public:
        bool check(S s) const {
            return (s.data[0] != 0 || s.data[1] != 0);
        }
    };
}

// Объявление проверочной функции
extern "C" void _ZL5checkb(bool condition);

// Реализация access6
extern "C" void access6(var6::C* c_obj, var6::S* s_data) {
    // Проверка младшего байта указателя на C
    if ((reinterpret_cast<unsigned long long>(c_obj) & 0xFF) == 0) {
        _ZL5checkb(false);  // Access Denied
        return;
    }

    // Проверка 2-го и 3-го байтов указателя на C  
    unsigned short* ptr_bytes = reinterpret_cast<unsigned short*>(&c_obj);
    if (ptr_bytes[1] != 0) {  // [rbp+arg_0+2] - смещение +2 байта
        // Копируем структуру S и вызываем проверку
        var6::S s_copy = *s_data;
        bool result = c_obj->check(s_copy);
        _ZL5checkb(result);
    }
    else {
        _ZL5checkb(false);  // Access Denied
    }
}

// Вспомогательные функции
extern "C" void _ZL5checkb(bool condition) {
    if (!condition) {
        // Access Denied - падение или сообщение
        printf("Access Denied\n");
        exit(1);
    }
    // Access Granted - продолжение работы
    printf("Access Granted\n");
}

// Функция main для тестирования
int main() {
    var6::C c_obj;
    var6::S s_data = { {0x123456789ABCDEF0, 0x0FEDCBA987654321} };

    // Тестовый вызов
    access6(&c_obj, &s_data);

    return 0;
}