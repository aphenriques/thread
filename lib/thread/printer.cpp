#include "printer.hpp"

namespace thread::printer::detail {
    std::mutex mutex;

    void print() {}

    void print(char character) {
        std::putchar(character);
    }

    void print(const char *string) {
        std::fputs(string, stdout);
    }

    void print(const std::string &string) {
        std::fputs(string.c_str(), stdout);
    }
}
