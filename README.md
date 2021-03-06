# thread

C++17 thread utility library.

Implements:

* `thread::Pool`: thread pool implementation (based on https://github.com/zserik/ThreadPool)
* `thread::printer::print`: thread-safe print function

# Build

Grab all the source files (*.hpp and *.cpp) in the `lib/thread` directory and build (there is no preprocessor configuration for the library).

Alternatively, build and install the library with:

    $ make
    $ make install

# Usage

[thread/Pool.hpp](lib/thread/Pool.hpp): `thread::Pool` class:

```c++
// create thread pool with 4 worker threads
thread::Pool pool(4);

// enqueue and store future
auto result = pool.enqueue(
    [](int answer) {
         return answer;
    },
    42
);

// get result from future
std::cout << result.get() << std::endl;
```

[thread/printer.hpp](lib/thread/printer.hpp): `thread::printer::print(...)` function:

```c++
// thread-safe stdout print function
thread::printer::print("number = ", 1, '\n');
// output:
// number = 1
//
```

# Example

[sample/pool/main.cpp](sample/pool/main.cpp):

```c++
#include <chrono>
#include <vector>
#include <thread/Pool.hpp>
#include <thread/printer.hpp>

int main() {
    thread::Pool pool(2);
    std::vector<std::future<int>> results;

    for (int i = 0; i < 4; ++i) {
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
// sample output (the order may vary):
// [0] start
// [1] start
// [0] end
// [1] end
// [2] start
// [0] result
// [1] result
// [3] start
// [2] end
// [3] end
// [2] result
// [3] result
```
