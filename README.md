# docker-cpp-dev

cpp development tools

## tags

images come in these flavors:

* latest: basic tools
* dev: development tag for latest
* opencv: add opencv to basic tools
* opencv-dev: develepment tag for opencv

## tools

* [clang](http://llvm.org/svn/llvm-project/)
* clnag-format
* make
* [opencv](https://opencv.org)
* vim
  * ctags
    * unite-outline plugin uses.
  * global
  * lua

## global

create global tags.

```bash
$ export GTAGSFORCECPP=1
$ gtags -v
```

## opencv

get flags:

```bash
$ pkg-config --cflags opencv
$ pkg-config --libs opencv
```

example:

```cpp
#include <iostream>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <string>

int main()
{
  const std::string FILEPATH("lenna.jpg");
  cv::Mat src = cv::imread(FILEPATH, cv::IMREAD_COLOR);
  if (src.empty()) {
    std::cerr << "Failed to open image file: " << FILEPATH;
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
```

