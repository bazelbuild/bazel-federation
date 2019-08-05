#include <iostream>

#include "hello_lib.h"

int main(int argc, char *argv[]) {
  std::cout << "Hello " << hello_lib_value() << std::endl;
}

