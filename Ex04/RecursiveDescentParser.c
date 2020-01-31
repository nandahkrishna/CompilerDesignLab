#include<stdio.h>
#include<stdlib.h>
void E();
void Eprime();
void T();
void Tprime();
void F();
char s;
int pos = 0;
void parse(char c)
{
    if(s == c) {
        s = getchar();
    }
    else {
        printf("Error at position %d!\n", pos);
        exit(0);
    }
}
void E()
{
    T();
    Eprime();
}
void Eprime()
{
    if(s == '+') {
        pos++;
        parse('+');
        T();
        Eprime();
    }
}
void T()
{
    F();
    Tprime();
}
void Tprime()
{
    if(s == '*') {
        pos++;
        parse('*');
        F();
        Tprime();
    }
}
void F()
{
    if(s == '(') {
        pos++;
        parse('(');
        E();
        pos++;
        parse(')');
    }
    else if(s == 'i') {
        pos++;
        parse('i');
        parse('d');
    }
    else {
        printf("Error at position %d!\n", pos);
        exit(0);
    }
}
int main()
{
    printf("Enter string to parse: ");
    s = getchar();
    E();
    printf("Parsed successfully!\n");
    return 0;
}
