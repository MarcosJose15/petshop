-- use petshop;

/* Relatório 1 - Lista dos empregados admitidos entre 2019-01-01 e 2022-03-31, trazendo as colunas 
(Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), ordenado por data de admissão decrescente; */

SELECT 	upper(emp.nome) "Empregado", emp.cpf as "CPF Empregado",
		date_format(emp.dataAdm, '%d/%m/%Y') "Data Admissão",
		concat("R$ ", format(emp.salario, 2, 'de_DE')) "Salário",
		dep.nome "Departamento",
		tel.numero "Telefone"
		from empregado emp
			left join departamento dep on emp.Departamento_idDepartamento = dep.idDepartamento
			left join telefone tel on emp.cpf = Empregado_cpf
				where emp.dataAdm between 2019-01-01 and 2023-03-31
					order by emp.dataAdm desc;

            
-- date_format(func.dataAdm, "%h:%i %d/%m/%Y") "Data de Admissão",

/* Relatório 2 - Lista dos empregados que ganham menos que a média salarial dos funcionários do Petshop, 
trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone),
 ordenado por nome do empregado; */

select 	upper(emp.nome) "Empregado", emp.cpf as "CPF Empregado",
		date_format(emp.dataAdm, '%d/%m/%Y') "Data Admissão",
		concat("R$ ", format(emp.salario, 2, 'de_DE')) "Salário",
		dep.nome "Departamento",
		tel.numero "Telefone"
		from empregado emp
			left join departamento dep on emp.Departamento_idDepartamento = dep.idDepartamento
			left join telefone tel on emp.cpf = Empregado_cpf
				where  emp.salario < (select avg(emp.salario) from empregado emp)
					order by emp.nome;

select avg(salario) from empregado;

/* Relatório 3 - Lista dos departamentos com a quantidade de empregados total por cada departamento, 
trazendo também a média salarial dos funcionários do departamento e a média de comissão recebida pelos 
empregados do departamento, com as colunas (Departamento, Quantidade de Empregados, Média Salarial, 
Média da Comissão), ordenado por nome do departamento; */

select 	upper(dep.nome) as "Departamento",
		count(emp.cpf) as "Quantidade de Empregados",
		avg(emp.salario) as "Média Salarial",
		avg(emp.comissao) as "Média da Comissão"
		from empregado emp
			inner join departamento dep ON emp.Departamento_idDepartamento = dep.idDepartamento
				group by dep.nome
					order by dep.nome;
    
/* Relatório 4 - Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado, além da soma do valor 
total das vendas do empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, 
Quantidade Vendas, Total Valor Vendido, Total Comissão das Vendas), ordenado por quantidade total de vendas realizadas; */

/* Relatório 4 - Lista dos empregados com a quantidade total de vendas já realizada por cada Empregado, além da soma do valor total das vendas do empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas, Total Valor Vendido, Total Comissão das Vendas), ordenado por quantidade total de vendas realizadas; */
SELECT 
    UPPER(emp.nome) AS "Nome Empregado",
    emp.cpf AS "CPF Empregado",
    emp.sexo AS "Sexo",
    emp.salario AS "Salário",
    COUNT(venda.idVenda) AS "Quantidade Vendas",
    SUM(venda.valor) AS "Total Valor Vendido",
    SUM(emp.comissao) AS "Total Comissão das Vendas"
FROM 
    empregado emp
INNER JOIN 
    venda ON emp.cpf = venda.Empregado_cpf
GROUP BY 
    emp.cpf
ORDER BY 
    "Quantidade Vendas" DESC;

/* Relatório 5 - Lista dos empregados que prestaram Serviço na venda computando a quantidade total de vendas realizadas com serviço por cada Empregado, além da soma do valor total apurado pelos serviços prestados nas vendas por empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas com Serviço, Total Valor Vendido com Serviço, Total Comissão das Vendas com Serviço), ordenado por quantidade total de vendas realizadas; */
SELECT 
    UPPER(emp.nome) AS "Nome Empregado",
    emp.cpf AS "CPF Empregado",
    emp.sexo AS "Sexo",
    emp.salario AS "Salário",
    COUNT(servico_venda.idServico) AS "Quantidade Vendas com Serviço",
    SUM(servico_venda.valor) AS "Total Valor Vendido com Serviço",
    SUM(emp.comissao) AS "Total Comissão das Vendas com Serviço"
FROM 
    empregado emp
INNER JOIN 
    servico_venda ON emp.cpf = servico_venda.Empregado_cpf
GROUP BY 
    emp.cpf
ORDER BY 
    "Quantidade Vendas com Serviço" DESC;

/* Relatório 6 - Lista dos serviços já realizados por um Pet, trazendo as colunas (Nome do Pet, Data do Serviço, Nome do Serviço, Quantidade, Valor, Empregado que realizou o Serviço), ordenado por data do serviço da mais recente a mais antiga; */
SELECT 
    pet.nome AS "Nome do Pet",
    servico.data AS "Data do Serviço",
    servico.nome AS "Nome do Serviço",
    servico.quantidade AS "Quantidade",
    servico.valor AS "Valor",
    emp.nome AS "Empregado que realizou o Serviço"
FROM 
    servico
INNER JOIN 
    pet ON servico.Pet_idPet = pet.idPet
INNER JOIN 
    empregado emp ON servico.Empregado_cpf = emp.cpf
ORDER BY 
    servico.data DESC;

/* Relatório 7 - Lista das vendas já realizadas para um Cliente, trazendo as colunas (Data da Venda, Valor, Desconto, Valor Final, Empregado que realizou a venda), ordenado por data da venda da mais recente a mais antiga; */
SELECT 
    venda.data AS "Data da Venda",
    venda.valor AS "Valor",
    venda.desconto AS "Desconto",
    (venda.valor - venda.desconto) AS "Valor Final",
    emp.nome AS "Empregado que realizou a venda"
FROM 
    venda
INNER JOIN 
    cliente ON venda.Cliente_cpf = cliente.cpf
INNER JOIN 
    empregado emp ON venda.Empregado_cpf = emp.cpf
ORDER BY 
    venda.data DESC;

/* Relatório 8 - Lista dos 10 serviços mais vendidos, trazendo a quantidade de vendas de cada serviço, o somatório total dos valores de serviço vendido, com as colunas (Nome do Serviço, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas; */
SELECT 
    servico.nome AS "Nome do Serviço",
    COUNT(servico_venda.idServico) AS "Quantidade Vendas",
    SUM(servico_venda.valor) AS "Total Valor Vendido"
FROM 
    servico_venda
INNER JOIN 
    servico ON servico_venda.Servico_idServico = servico.idServico
GROUP BY 
    servico.nome
ORDER BY 
    "Quantidade Vendas" DESC
LIMIT 10;

/* Relatório 9 - Lista das formas de pagamentos mais utilizadas nas Vendas, informando quantas vendas cada forma de pagamento 
já foi relacionada, trazendo as colunas (Tipo Forma Pagamento, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade
 total de vendas realizadas; */

/* Relatório 10 - Balaço das Vendas, informando a soma dos valores vendidos por dia, trazendo as colunas (Data Venda, Quantidade de Vendas,
 Valor Total Venda), ordenado por Data Venda da mais recente a mais antiga; */

/* Relatório 11 - Lista dos Produtos, informando qual Fornecedor de cada produto, trazendo as colunas 
(Nome Produto, Valor Produto, Categoria do Produto, Nome Fornecedor, Email Fornecedor, Telefone Fornecedor), 
ordenado por Nome Produto; */

/* Relatório 12 - Lista dos Produtos mais vendidos, informando a quantidade (total) de vezes que cada produto participou 
em vendas e o total de valor apurado com a venda do produto, trazendo as colunas (Nome Produto, Quantidade (Total) Vendas, 
Valor Total Recebido pela Venda do Produto), ordenado por quantidade de vezes que o produto participou em vendas */