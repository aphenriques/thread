#include "Executor.hpp"

namespace thread {
    Executor::Executor(std::size_t numberOfThreads) : pool_(numberOfThreads) {}

    Executor::~Executor() {
        join();
    }

    void Executor::join() {
        while (futures_.empty() == false) {
            futures_.front().get();
            futures_.pop();
        }
    }
}
