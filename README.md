# polynmial_degree
function that given an array of elements decides what's the lowest possible degree of a polynomial 

##Minimalny stopień wielomianu

Zaimplementuj w asemblerze funkcję polynomial_degree wołaną z języka C o sygnaturze:

int polynomial_degree(int const *y, size_t n);

Argumentami funkcji są wskaźnik y na tablicę liczb całkowitych y0, y1, y2, …, yn−1 i n zawierający długość tej tablicy n. Wynikiem funkcji jest najmniejszy stopień wielomianu w(x) jednej zmiennej o współczynnikach rzeczywistych, takiego że w(x+kr)=yk dla pewnej liczby rzeczywistej x, pewnej niezerowej liczby rzeczywistej r oraz k=0,1,2,…,n−1.

Przyjmujemy, że wielomian tożsamościowo równy zeru ma stopień −1. Wolno założyć, że wskaźnik y jest poprawny i wskazuje na tablicę zawierającą n elementów, a n ma dodatnią wartość.
