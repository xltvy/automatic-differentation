# automatic-differentation

Bogazici University

Computer Engineering Department

Spring 2021

CMPE 260 - Principles of Programming Languages

Project 2

Altay Acar

***

Automatic differentation algorithm to compute partial gradients of an expression by a repetitive application of the chain rule of calculus for racket language.

Descpription:

- data structure num with two fields: value and grad. value will hold the value of the number, and grad is for holding the partial gradient of a function with respect to this parameter.

- (get-value num-list )
This procedure will return the values of numbers in num-list as a list. If num-list is a num, then
the return result should be a number.

- (get-grad num-list )
This procedure will return the gradient field of numbers in num-list as a list. If num-list is a
num, then the return result should be a number.

- Extension of +, -, and * operators so that they will also compute the gradients of their arguments. These operators will return a num struct.

- (add num1 num2 ...)
The derivative of add operator is the sum of gradients of its terms. This is rather easy, for the
value, you will sum the values of numbers, and for the gradient, you will sum the gradients.

- (mul num1 num2 ...)
For the value, you will multiply all the numbers’ values. For the gradient, the derivative of mul
operator is the sum of multiplication of each term’s gradient with others’ values.

- (sub num1 num2 )
For the value, you will subtract num2 from num1 . For the gradient, the derivative of sub is the
subtraction of num2 ’s gradients from num1 ’s gradients.

- (create-hash names values var )
Given a list of symbols in names , respective values in values , and variable at interest in var , you will create a hash which contains numbers for each symbol with appropriate gradients. Here, initial gradients of each number will be 0 except for var , for which it will be 1.

- (parse hash expr )
In this procedure, you will implement a simple parser which will translate the symbolic expression in expr into an appropriate expression by converting symbols in expr into their respective numbers in hash . For example, if we see x in expr , we will convert it into its number in hash . Operations in expr can be one of the following: +, *, -, mse, relu. Here, you have to convert * to mul, and so on. If you encounter a number in expr , you will construct the number with 0 gradient.

- (grad names values var expr )
Given a list of symbols in names with respective values in values, take partial derivative of the expr with respect to var and return it. If you have implemented all the other parts, this procedure should be easy; you have all the tools you need.

- (partial-grad names values vars expr )
This is similar to grad except now we return a list of partial derivatives of expr with respect to each symbol in names . Here, if a symbol in names is not in vars , we treat it as a constant and its gradient should be 0. It should be easy to implement this procedure using grad (hint: for all elements in name , take grad if it is in vars , otherwise fill with 0).

- (gradient-descent names values vars lr expr)
We are approaching the end. Now that we have everything in our toolbox, we can start optimizing our differentiable parameters (i.e. parameters that are in vars) to minimize an objective. In this procedure, you will implement a single iteration of the following equation for our parameter set:
  > values = values − lr ∗ ∇values (expr)

- (optimize names values vars lr k expr)
In this procedure, you will run gradient-descent iteratively k times. That is, the returning result of gradient-descent call should be the new values. In another words, you will call gradient-descent recursively k times and at each iteration you will its result for values in the next call.

Prohibited Constructs:
1. Any function or language element that ends with an !.
2. Any of these constructs: begin, begin0, when, unless, for, for*, do, set!-values.
3. Any language construct that starts with for/ or for*/.
4. Any construct that causes any form of mutation (impurity).
