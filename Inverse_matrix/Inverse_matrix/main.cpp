#include <iostream>
#include <cmath>
using namespace std;

void print(double** matrix, const int& n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            cout << matrix[i][j] << " ";
        }
        cout << endl;
    }
}

double** create_memory(const int& n) {
    double** result = new double*[n];
    for (int i = 0; i < n; i++) {
        result[i] = new double[n];
    }
    return result;
}

double** create_matrix_manual(const int&n) {
    double** matrix = new double* [n];
    for (int i = 0; i < n; i++) {
        matrix[i] = new double[n];
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            cout << "Enter [" << i << ";" << j << "] element: ";
            cin >> matrix[i][j];
        }
    }
    return matrix;
}
double** create_matrix_random(const int& n) {
    double** matrix = new double* [n];
    for (int i = 0; i < n; i++) {
        matrix[i] = new double[n];
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            matrix[i][j] = -10 + (rand() % 21); //rand numbers in range -10 to 10
        }
    }
    return matrix;
}
void delete_matrix(double** matrix,const int& n) {
    for (int i = 0; i < n; i++) {
        delete[] matrix[i];
    }
    delete[]matrix;
}

int matrix_det(double** matrix, int n) {
    if (n == 1)
        return matrix[0][0];
    else if (n == 2)
        return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];
    else {
        int d = 0;
        for (int k = 0; k < n; k++) {
            double** m = new double* [n - 1];
            for (int i = 0; i < n - 1; i++) {
                m[i] = new double[n - 1];
            }
            for (int i = 1; i < n; i++) {
                int t = 0;
                for (int j = 0; j < n; j++) {
                    if (j == k)
                        continue;
                    m[i - 1][t] = matrix[i][j];
                    t++;
                }
            }
            d += pow(-1, k + 2) * matrix[0][k] * matrix_det(m, n - 1);
            delete_matrix(m, n - 1);
        }
        return d;
    }
}

double** transpose(double** matrix, const int& n){
    double** res = create_memory(n);

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            res[i][j] = matrix[j][i];
        }
    }
    return res;
}



double** get_minor(double** matrix, int x, int y, int size)
{
    int xCount = 0, yCount = 0;
    int i, j;
    double** minor = new double* [size - 1];
    for (int i = 0; i < size; i++) {
        minor[i] = new double[size - 1];
    }

    for (i = 0; i < size; i++) {
        if (i != x) {
            yCount = 0;
            for (j = 0; j < size; j++) {
                if (j != y) {
                    minor[xCount][yCount] = matrix[i][j];
                    yCount++;
                }
            }
            xCount++;
        }
    }
    return minor;
}

double** matrix_minor(double** matrix, int size)
{
    int i, j;

    double det = matrix_det(matrix, size);

    double** result = new double* [size];
    for (int i = 0; i < size; i++) {
        result[i] = new double[size];
    }

    if (det > 0)
        det = -1;
    else
        det = 1;
    double** minor;

    for (j = 0; j < size; j++){
        for (i = 0; i < size; i++){
            minor = get_minor(matrix, j, i, size);
            if ((i + j) % 2 == 0)
                result[j][i] = -det * matrix_det(minor, size - 1);
            else
                result[j][i] = det * matrix_det(minor, size - 1);
        }
    }
    return result;
}

double** reverse_matrix(double** matrix, const int& n) {
    double** result = create_memory(n);
    
    double det = matrix_det(matrix, n);
    double** minor = matrix_minor(matrix, n);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            result[i][j] = minor[i][j] / det;
        }
    }

    return transpose(result, n);
}


int main()
{
    int n, choice;
    double** matrix;
    cout << "Matrix nxn"<<endl;
    cout << "Enter n: "; cin >> n;

    cout << "1. Manual\n2. Random\n\nSelect input: "; cin >> choice;
    if (choice == 1) {
        matrix = create_matrix_manual(n);
        cout << "Matrix:" << endl;
        print(matrix, n);
        cout << "\nMatrix determinant: " << matrix_det(matrix, n) << endl;
        cout << "\nReversed matrix:\n"; print(reverse_matrix(matrix, n), n);
        delete_matrix(matrix, n);
    }
    else if (choice == 2) {
        matrix = create_matrix_random(n);
        cout << "Matrix:" << endl;
        print(matrix, n);
        cout <<"\nMatrix determinant: "<< matrix_det(matrix, n) << endl;
        cout << "\nReversed matrix:\n"; print(reverse_matrix(matrix, n), n);

        delete_matrix(matrix, n);
    }
    else {
        cout << "Wrong input choice!" << endl;
    }

}
