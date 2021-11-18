#include <iostream>
#include <vector>

template <typename T>
class Stack {
    private:
        std::vector<T> values;
    public:
        void push(T);
        T pop();
        T peek();
};

template <typename T>
void Stack<T>::push(T value) {
    this->values.push_back(value);
}

template <typename T>
T Stack<T>::pop() {
    T temp = this->values.back();
    this->values.pop_back();
    return temp;
}

template <typename T>
T Stack<T>::peek() {
    return this->values.back();
}

int main() {
    Stack<int> *primitiveStack = new Stack<int>();
    primitiveStack->push(1);
    primitiveStack->push(2);
    std::cout << primitiveStack->pop() << std::endl;
}
