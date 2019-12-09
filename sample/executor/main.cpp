#include <chrono>
#include <iostream>
#include <thread/Executor.hpp>
#include <thread/printer.hpp>

int main() {
    thread::Executor executor(2);

    for (int i = 0; i < 3; ++i) {
        executor.enqueue(
            [i] {
                thread::printer::print('[', i, "] start\n");
                std::this_thread::sleep_for(std::chrono::seconds(1));
                thread::printer::print('[', i, "] end\n");
                return i;
            }
        );
    }

    executor.join();
    std::cout << "--" << std::endl;

    for (int i = 3; i < 6; ++i) {
        executor.enqueue(
            [i] {
                thread::printer::print('[', i, "] start\n");
                std::this_thread::sleep_for(std::chrono::seconds(1));
                thread::printer::print('[', i, "] end\n");
                return i;
            }
        );
    }
    executor.join();

    return EXIT_SUCCESS;
}
