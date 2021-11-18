#include <iostream>

struct Person {
    double age;
};

int main() {
    Person developer;

    std::cout << "What is your age? " << std::endl;
    std::cin >> developer.age;

    std::cout << "You are " << developer.age << " Years old!" << std::endl;
    return 0;
}
