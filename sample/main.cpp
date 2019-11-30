#include <chrono>
#include <iostream>
#include <utility>
#include <vector>
#include <thread/Pool.hpp>
#include <thread/printer.hpp>

int main() {
    thread::Pool pool(4);
    std::vector<std::future<int>> results;

    for (int i = 0; i < 8; ++i) {
        results.emplace_back(
            pool.enqueue(
                [i] {
                    thread::printer::print('[', i, "] start\n");
                    std::this_thread::sleep_for(std::chrono::seconds(1));
                    thread::printer::print('[', i, "] end\n");
                    return i;
                }
            )
        );
    }

    for (auto &&result : results) {
        thread::printer::print('[', result.get(), "] result\n");
    }

    return EXIT_SUCCESS;
}
