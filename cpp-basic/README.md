# docker-cpp-dev

cpp development tools

## tags

images come in these flavors:

* latest: basic tools
* dev: development tag for latest
* boost: add boost to basic tools
* boost-dev: development tag for boost
* opencv: add opencv to basic tools
* opencv-dev: develepment tag for opencv
* atcoder: build tools for atcoder.(not complete)
* atcoder-dev: development tag for atcoder.(not complete)

## tools

* [boost](http://www.boost.org/)
* [clang](http://llvm.org/svn/llvm-project/)
* clnag-format
* make
* [opencv](https://opencv.org)
* pkg-config
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

## boost

get flags:

```bash
# replace xxx to module name. for example: boost_regex
$ pkg-config --cflags boost_xxx
$ pkg-config --libs boost_xxx
```

example:

```cpp
#include <algorithm>
#include <boost/lambda/lambda.hpp>
#include <iostream>
#include <iterator>

int main()
{
    using namespace boost::lambda;
    typedef std::istream_iterator<int> in;

    std::for_each(in(std::cin), in(), std::cout << (_1 * 3) << " " );

    return EXIT_SUCCESS;
}
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

