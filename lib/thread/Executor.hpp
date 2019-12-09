#ifndef thread_Executor_hpp
#define thread_Executor_hpp

#include "Pool.hpp"

namespace thread {
    class Executor {
    public:
        Executor(std::size_t numberOfThreads);

        template<class F, class... A>
        void enqueue(F &&callable, A &&...arguments);

        // waits completion of each enqueued task
        // other tasks may be enqueued after calling this method
        void join();

    private:
        Pool pool_;
        std::queue<std::future<void>> futures_;
    };

    template<class F, class... A>
    void Executor::enqueue(F&& callable, A &&...arguments) {
        futures_.emplace(pool_.enqueue(std::bind<void>(std::forward<F>(callable), std::forward<A>(arguments)...)));
    }
}

#endif
