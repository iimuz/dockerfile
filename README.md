# docker-cpp-dev

cpp development tools

## tools

* clang
* clnag-format
* make
* opencv
* vim
  * ctags
  * global
  * libc-dev
  * lua

## global

create global tags.

```bash
$ export GTAGSFORCECPP=1
$ gtags -v
```

## opencv

sample code:

```cpp
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <iostream>

int main(int argc, const char* argv[])
{
    cv::Mat src = cv::imread("hoge.jpg", cv::IMREAD_COLOR);
    if (src.empty()) {
        std::cerr << "Failed to open image file.\n";
        return EXIT_FAILURE;
    }

    cv::imwrite("hoge2.jpg", src);

    return EXIT_SUCCESS;
}
```
