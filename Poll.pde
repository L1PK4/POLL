float SLOW = 0.002; // Коэффицента замедления


boolean drawing_traectory = false; //Флаг, отвечающий за отрисовку траекторий

// Класс шара для боулинга
class Ball  
{
	// Переменные класса, отвечающие за положение, скорость, отслеживание траектории и цвет
	float x, y, Vx, Vy, pastX, pastY;
	float traectory[][];
	int counter = 0;
	color cl;
	//Конструктор класса 
	Ball (float _x, float _y, float _Vx, float _Vy) 
	{
		pastX = x = _x;
		pastY = y = _y;
		Vx = _Vx;
		Vy = _Vy;
		// Задаём случайный цвет
		cl = color(int(100 + random(0, 155)), int(100 + random(0, 155)), int(100 + random(0, 155)));
		traectory = new float[1000000][];
		traectory[0] = new float[2];
		traectory[0][0] = x;
		traectory[0][1] = y;
	}
	// Метод обновления положения шара
	void update()
	{
		// Столкновение со стеной
		if (x >= width || x <= 0) {
			Vx = -Vx;
		}
		if (y >= height || y <= 0) {
			Vy = -Vy;
		}
		// сохранение траектории
		if ( pow(pastX - x, 2) + pow(pastY - y, 2) >= 100)
		{
			traectory[++counter] = new float[2];
			pastX = traectory[counter][0] = x;
			pastX = traectory[counter][1] = y;
		}
		// Движение
		x += Vx;
		y += Vy;
		// Замедление
		Vx *= 1 - SLOW;
		Vy *= 1 - SLOW;
	}
	// Метод отображения шара и траектории (если нужно)
	void display()
	{
		fill(cl);
		ellipse(x, y, 10, 10);
		if (drawing_traectory)
			for (int i = 0; i < counter; i += 2) {
				line(traectory[i][0], traectory[i][1], traectory[i + 1][0], traectory[i + 1][1]);
			}
	}

}
//Объявление массива шаров
Ball balls[];
int count = -1;

//Настройка экрана
void setup() {
    size(1000, 640);
	fill(0, 0, 0, 255);
	balls = new Ball[10000000];  
}

boolean inCreating = false;
float ball_x, ball_y;


// Функция, которая рисует на экран 
void draw() {
    background(10, 180, 10);
	
	// Создание нового шара путём выбора места и направления мышкой
	if (!mousePressed && inCreating && abs(ball_x - mouseX) > 10 && abs(ball_y - mouseY) > 10)
	{
		  balls[++count] = new Ball(ball_x, ball_y, 0.02 * (ball_x - mouseX), 0.02 * (ball_y - mouseY));
  		inCreating = false;
  	}

	if(mousePressed && !inCreating)
	{
		ball_x = mouseX;
		ball_y = mouseY;
		inCreating = true;
	}
	if (inCreating && mousePressed) {
		line(ball_x, ball_y, mouseX, mouseY);
	}
	// Циклом пробегаем по всем шарам, обновляем их и рисуем
	for (int i = 0; i <= count; ++i) {
		balls[i].update();
		balls[i].display();
	}
}
// Функция, проверяющая нажата ли кнопка
void keyPressed() 
{
	drawing_traectory = !drawing_traectory;
}
