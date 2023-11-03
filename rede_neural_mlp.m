% Autor: Paulo Ricardo dos Santos Sousa
% Matrícula: 495757


%-------------------------TRATAMENTO DE DADOS------------------------------

data=importdata("column_3C.dat");
%Separando dados por colunas
data=split(data,' ');
%Convertendo dados em ponto flutuante
data=str2double(data);
%Apagando coluna de classes
data(:,7)=[];
%Normalização
data=(data-min(data,[],'all'))./(max(data,[],'all')-min(data,[],'all'));
%Adicionando 3 novas colunas de modo que 
% [1 0 0] -----> Hernia
% [0 1 0] -----> Spondylolisthesis
% [0 0 1] -----> Normal
dados=ones(1,9);
for i=1:60
    dados(i,:)=[data(i,:),[1 0 0]];
end
for i=61:210
    dados(i,:)=[data(i,:),[0 1 0]];
end
for i=211:310
    dados(i,:)=[data(i,:),[0 0 1]];
end

acuracia=0;
for a=1:10
%--------------------GERANDO DADOS DE TREINAMENTO E TESTE------------------


%Gerando 30% de indices aleatorios para dados de treianmento
rand_test=sort(randperm(310,93));

%Gerando 70% de indices para dados de treinamento fazendo a remoção dos
%indices de casos de teste do vetor de indices da base de dados
rand_train=1:310;
for i=1:93
    rand_train=rand_train(rand_train~=rand_test(i));
end

%Criando matriz com dados de treinamento
x=zeros(1,9);
for i=1:217
    x(i,:)=dados(rand_train(i),:);
end
x=x';
x_train=x(1:6,:); % Matriz com entradas de treinamento
d_train=x(7:9,:); % Matriz de saídas esperadas(classes correspondentes) 

%Criando matriz com dados de teste
data_test=zeros(1,9);
for i=1:93
    data_test(i,:)=dados(rand_test(i),:);
end
data_test=data_test';
x_test=data_test(1:6,:); % Matriz com entradas de teste
d_test=data_test(7:9,:); % Matriz de saídas esperadas(classes correspondentes)


%-------------------------TREINAMENTO DA REDE NEURAL-----------------------

net = feedforwardnet(10);
net.trainParam.showWindow=false;
net=configure(net,x_train,d_train);
net.trainParam.epochs=1000;
net=train(net,x_train,d_train);
y_test=net(x_test);

%----------------------------CÁLCULO DA ACURÁCIA---------------------------


acuracia=[acuracia;Acuracia(d_test,y_test)];
end
acuracia_media=sum(acuracia)/10

%Função para cálculo da acurácia
function Calc_acuracia=Acuracia(d_test,y_test)
cont=0;
    for i=1:length(y_test)
        for j=1:3
            % Compara a i-ésima coluna de y com o valor
            % máximo dessa coluna a fim de obter sua posição j
            if y_test(j,i)==max(y_test(:,i))
                %Verifica se a posição j da i-ésima coluna de d_test tem 1
                if d_test(j,i)==1
                    cont=cont+1;
                end
            end
        end
    end
    Calc_acuracia=cont/length(y_test);
end


