#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <cmath>
#include <cstring>

// Структура S как восстановлено из дизассемблера
struct S {
    uint8_t x;     // [0]  -- проверяется на ноль и используется в сравнении
    uint8_t pad;   // [1]  -- паддинг / неиспользуемый байт
    uint16_t y;    // [2..3] -- используется (как signed у нас в сравнении через neg)
};

// Класс C: два поля double подряд
struct C {
    double A;   // 8 байт
    double B;   // 8 байт

    // Восстановленный метод check(const S&)
    bool check(const S& s) const {
        // Берём битовое представление double A как 64-битное целое,
        // точно так же, как в дизассемблере читался QWORD.
        uint64_t bits;
        static_assert(sizeof(bits) == sizeof(A));
        std::memcpy(&bits, &A, sizeof(bits));

        // Gray-код и подсчёт единиц (интерпретация intent: popcount(bits ^ (bits>>1)))
        uint64_t gray = bits ^ (bits >> 1);

        // В дизассемблере цикл делался 63 итерации; здесь логика
        // интуитивно - считаем единичные биты в gray для полной гарантии:
        int cnt = 0;
        // Считаем все биты (popcount)
        while (gray) {
            cnt += (gray & 1);
            gray >>= 1;
        }

        // Условие: если s.x <= cnt, то проверяем второе условие с frexp(B,&Y)
        if (s.x <= cnt) {
            int Y;
            (void)frexp(B, &Y); // frexp возвращает мантиссу, Y — экспонента
            // В дизассемблере сравнение было: return (- (int)s.y) > Y;
            int neg_y = -static_cast<int>(s.y);
            return (neg_y > Y);
        }

        return false;
    }
};

// Поведение check(bool) из дизассемблера:
// Если false -> печать "Access denied" и exit(-1)
// Если true  -> печать "Access granted" и возврат (в дизассемблере puts возвращается).
int check_bool(bool v) {
    if (!v) {
        puts("Access denied");
        exit(-1);
    }
    puts("Access granted");
    return 0;
}

// Восстановленная функция access6: принимает S по значению и C (как ссылка/ptr)
void access6(S a, const C& c) {
    // Начальная проверка (как в дизассемблере):
    // если байт a.x == 0  или  word a.y == 0  -> check(false)
    if (a.x == 0 || a.y == 0) {
        check_bool(false);
        return; // не достижимо, exit(-1) внутри
    }

    // Вызов метода C::check
    bool ok = c.check(a);

    // Финальная проверка/вывод
    check_bool(ok);
}

int main() {
    // Подбираем параметры, которые гарантированно выдадут "Access granted".
    // Требования:
    // 1) a.x != 0 и a.y != 0 (иначе сразу "Access denied")
    // 2) a.x <= popcount( bits(A) ^ (bits(A) >> 1) )
    // 3) (- (int)a.y) > exponent(B)  (exp = Y из frexp(B,&Y))

    S s{};
    s.x = 1;     // !=0, и достаточно мало, чтобы войти в условие при нормальном A
    s.pad = 0;
    s.y = 1;     // !=0; -s.y == -1

    C c{};
    // Подставим A и B удобные для выполнения условий:
    // A = 1.0 : имеет битовое представление с некоторыми единицами — popcount(gray) > 0
    // B = 0.1 : frexp(0.1, &Y) даёт Y приблизительно -3 (т.е. -1 > -3 -> true)
    c.A = 1.0;
    c.B = 0.2;

    // Вызов восстановленной функции
    access6(s, c);

    return 0;
}