#include <stdio.h>
#include <stdlib.h>

void f()
{
    char arr[5];
    // cppcheck-suppress arrayIndexOutOfBounds
    // cppcheck-suppress unreadVariable
    arr[10] = 0;
}

int main()
{
    f();
    return 0;
}
