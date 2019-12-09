#ifndef thread_Pool_hpp
#define thread_Pool_hpp

#include <functional>
#include <future>
#include <queue>

namespace thread {
    class Pool {
    public:
        Pool(std::size_t numberOfThreads);

        // joins all threads
        ~Pool();

        template<class F, class... A>
        decltype(auto) enqueue(F &&callable, A &&...arguments);

    private:
        std::vector<std::thread> threads_;
        std::queue<std::packaged_task<void()>> tasks_;
        std::mutex mutex_;
        std::condition_variable condition_;
        bool stopped_;
    };

    template<class F, class... A>
    decltype(auto) Pool::enqueue(F&& callable, A &&...arguments) {
        using ReturnType = std::invoke_result_t<F, A...>;
        std::packaged_task<ReturnType()> task(std::bind(std::forward<F>(callable), std::forward<A>(arguments)...));
        std::future<ReturnType> taskFuture = task.get_future();
        {
            std::unique_lock<std::mutex> lock(mutex_);
            tasks_.emplace(std::move(task));
            // attention! task moved
        }
        condition_.notify_one();
        return taskFuture;
    }
}

#endif
