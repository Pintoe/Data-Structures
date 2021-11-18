import java.util.ArrayList;

public class PrimitiveStack<StackType> {   
    
    int top = -1;
    ArrayList<StackType> values = new ArrayList<StackType>();
    StackType fillerValue = ( (StackType[]) new Object[1] )[0];
    // final String stackType = fillerValue.getClass().getName();
    
    PrimitiveStack(StackType... newObjects) {
        for (StackType object : newObjects) {
            this.push(object);
        }
    }
    
    public StackType peek() {
        if (this.top == -1) {
            return fillerValue;
        } else {
            return this.values.get(this.top);
        }
    }
    
    public void push(StackType valueToPush) {
        this.top += 1;
        this.values.add(valueToPush);
    }
    
    public StackType pop() {
        if (this.top == -1) {
            return fillerValue;
        } else {
            StackType valuePopped = this.peek();
            this.values.remove(this.top);
            this.top -= 1;
            return valuePopped;
        }
    }
    
    public int length() {
        return this.top+1;
    }
    
    public boolean find(StackType value) {
        for (StackType object : this.values) {
            if (object == value) {
                return true;
            }
        }
        
        return false;
    }
    
    public void cleanUp() {
        this.values.clear();
    }
}
