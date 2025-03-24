/*MÓDULO 11: EXERCÍCIOS
1. O setor de vendas decidiu aplicar um desconto aos produtos de acordo com a sua classe. O
percentual aplicado deverá ser de:
Economy -> 5%
Regular -> 7%
Deluxe -> 9%
a) Faça uma consulta à tabela DimProduct que retorne as seguintes colunas: ProductKey,
ProductName, e outras duas colunas que deverão retornar o % de Desconto e UnitPrice com
desconto.
b) Faça uma adaptação no código para que os % de desconto de 5%, 7% e 9% sejam facilmente
modificados (dica: utilize variáveis).*/

Declare @varDesEco Float, @varDesReg Float, @varDesDe Float
Set @varDesEco = 0.10
Set @varDesReg = 0.07
Set @varDesDe = 0.09

SELECT 
    ProductKey as 'ID do Produto',
    ProductName as 'Nome do Produto',
	ClassName as 'Classe',
	UnitPrice as 'Preço',
    Case
        When ClassName = 'Economy' then UnitPrice * (1 - @varDesEco)
        When ClassName = 'Regular' then UnitPrice * (1 - @varDesReg)
        When ClassName = 'Deluxe' then UnitPrice * (1 - @varDesDe)
	End as 'Valor com Desconto'
From
    DimProduct

/*2. Você ficou responsável pelo controle de produtos da empresa e deverá fazer uma análise da
quantidade de produtos por Marca.
A divisão das marcas em categorias deverá ser a seguinte:
CATEGORIA A: Mais de 500 produtos
CATEGORIA B: Entre 100 e 500 produtos
CATEGORIA C: Menos de 100 produtos
Faça uma consulta à tabela DimProduct e retorne uma tabela com um agrupamento de Total de
Produtos por Marca, além da coluna de Categoria, conforme a regra acima.*/

Select
	BrandName as 'Marca',
	Count(*) as 'Nº de Produtos',
	Case
		When Count(*) > 500 then 'A'
		When Count(*) between 100 and 500 then 'B'
		When Count(*) < 100 then 'C'
	End as 'Categoria'
From
	DimProduct
Group By BrandName
Order By Count(*)

/*3. Será necessário criar uma categorização de cada loja da empresa considerando a quantidade de
funcionários de cada uma. A lógica a ser seguida será a lógica abaixo:
EmployeeCount >= 50; 'Acima de 50 funcionários'
EmployeeCount >= 40; 'Entre 40 e 50 funcionários'
EmployeeCount >= 30; 'Entre 30 e 40 funcionários'
EmployeeCount >= 20; 'Entre 20 e 30 funcionários'
EmployeeCount >= 40; 'Entre 10 e 20 funcionários'
Caso contrário: 'Abaixo de 10 funcionários'
Faça uma consulta à tabela DimStore que retorne as seguintes informações: StoreName,
EmployeeCount e a coluna de categoria, seguindo a regra acima.*/

Select
	StoreName as 'Nome da Loja',
	EmployeeCount as 'Nº de Colaboradores',
	Case
		When EmployeeCount >= 50 then 'Acima de 50 funcionários'
		When EmployeeCount >= 40 then 'Entre 40 e 50 funcionários'
		When EmployeeCount >= 30 then 'Entre 30 e 40 funcionários'
		When EmployeeCount >= 20 then 'Entre 20 e 30 funcionários'
		When EmployeeCount >= 40 then 'Entre 10 e 20 funcionários'
		Else 'Abaixo de 10 Funcionarios'
	End as 'Categoria'
From
	DimStore

/*4. O setor de logística deverá realizar um transporte de carga dos produtos que estão no depósito
de Seattle para o depósito de Sunnyside.
Não se tem muitas informações sobre os produtos que estão no depósito, apenas se sabe que
existem 100 exemplares de cada Subcategoria. Ou seja, 100 laptops, 100 câmeras digitais, 100
ventiladores, e assim vai.
O gerente de logística definiu que os produtos serão transportados por duas rotas distintas. Além
disso, a divisão dos produtos em cada uma das rotas será feita de acordo com as subcategorias (ou
seja, todos os produtos de uma mesma subcategoria serão transportados pela mesma rota):
Rota 1: As subcategorias que tiverem uma soma total menor que 1000 kg deverão ser
transportados pela Rota 1.
Rota 2: As subcategorias que tiverem uma soma total maior ou igual a 1000 kg deverão ser
transportados pela Rota 2.
Você deverá realizar uma consulta à tabela DimProduct e fazer essa divisão das subcategorias por
cada rota. Algumas dicas:
- Dica 1: A sua consulta deverá ter um total de 3 colunas: Nome da Subcategoria, Peso Total e Rota.
- Dica 2: Como não se sabe quais produtos existem no depósito, apenas que existem 100
exemplares de cada subcategoria, você deverá descobrir o peso médio de cada subcategoria e
multiplicar essa média por 100, de forma que você descubra aproximadamente qual é o peso total
dos produtos por subcategoria.
- Dica 3: Sua resposta final deverá ter um JOIN e um GROUP BY.*/

Select * from DimProduct

Select
	ProductSubcategoryName as 'Sub-Categoria',
	Round(Avg(Weight) * 100, 2) as 'Peso Total',
	Case
		When Sum(Weight) < 1000 Then 'Rota 1'
		When Sum(Weight) >= 1000 then 'Rota 2'
	End as 'Rota'
From
	DimProduct
Inner Join DimProductSubcategory
	on DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
Group By ProductSubcategoryName
Having Sum(Weight) is not null


/*5. O setor de marketing está com algumas ideias de ações para alavancar as vendas em 2021. Uma
delas consiste em realizar sorteios entre os clientes da empresa.
Este sorteio será dividido em categorias:
‘Sorteio Mãe do Ano’: Nessa categoria vão participar todas as mulheres com filhos.
‘Sorteio Pai do Ano’: Nessa categoria vão participar todos os pais com filhos.
‘Caminhão de Prêmios’: Nessa categoria vão participar todas os demais clientes (homens e
mulheres sem filhos).
Seu papel será realizar uma consulta à tabela DimCustomer e retornar 3 colunas:
- FirstName AS ‘Nome’
- Gender AS ‘Sexo’
- TotalChildren AS ‘Qtd. Filhos’
- EmailAdress AS ‘E-mail’
- Ação de Marketing: nessa coluna você deverá dividir os clientes de acordo com as categorias
‘Sorteio Mãe do Ano’, ‘Sorteio Pai do Ano’ e ‘Caminhão de Prêmios’.*/
Select * From DimCustomer

Select
	Concat(FirstName, ' ', LastName) as 'Nome do Cliente',
	Case
		When Gender = 'F' Then 'Feminino'
		else 'Masculino'
	End as 'Sexo',
	TotalChildren as 'Nº de Filhos',
	EmailAddress as 'Email',
	Case
		When Gender = 'F' and TotalChildren > 0 then 'Sorteio Mãe do Ano'
		When Gender = 'M' and TotalChildren > 0 then 'Sorteio Pai do Ano'
		Else 'Caminhão de Prêmios'
	End as 'Ação de Marketing'
From
	DimCustomer

/*6. Descubra qual é a loja que possui o maior tempo de atividade (em dias). Você deverá fazer essa
consulta na tabela DimStore, e considerar a coluna OpenDate como referência para esse cálculo.
Atenção: lembre-se que existem lojas que foram fechadas.*/

Select * From DimStore

Select
	StoreName as 'Nome da Loja',
	OpenDate as 'Data da Inauguração',
	Status,
	Case
		When CloseDate is null Then DateDiff(Day, OpenDate, GetDate())
		Else DateDiff(Day, OpenDate, CloseDate)
	End as 'Dias abertos'
From
	DimStore
Order By DateDiff(Day, OpenDate, GetDate()) Desc