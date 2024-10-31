-- use petshop;

/* Relatório 1 - Lista dos empregados admitidos entre 2019-01-01 e 2022-03-31, trazendo as colunas 
(Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), ordenado por data de admissão decrescente; */

select 	upper(emp.nome) "Empregado", emp.cpf as "CPF Empregado",
		date_format(emp.dataAdm, '%d/%m/%Y') "Data Admissão",
		concat("R$ ", format(emp.salario, 2, 'de_DE')) "Salário",
		dep.nome "Departamento",
		tel.numero "Telefone"
        from empregado emp
			left join departamento dep on emp.Departamento_idDepartamento = dep.idDepartamento
			left join telefone tel on emp.cpf = Empregado_cpf
				where emp.dataAdm between 2019-01-01 and 2023-03-31
					order by emp.dataAdm desc;

            

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
				where  emp.salario < (select avg(emp.salario) as empregado)
					order by emp.nome;

select avg(salario) as empregado;

/* Relatório 3 - Lista dos departamentos com a quantidade de empregados total por cada departamento, 
trazendo também a média salarial dos funcionários do departamento e a média de comissão recebida pelos 
empregados do departamento, com as colunas (Departamento, Quantidade de Empregados, Média Salarial, 
Média da Comissão), ordenado por nome do departamento; */

select 	upper(dep.nome) as "Departamento",
		count(emp.cpf) as "Quantidade de Empregados",
		avg(emp.salario) as "Média Salarial",
		avg(emp.comissao) as "Média da Comissão"
		from empregado emp
			inner join departamento dep on emp.Departamento_idDepartamento = dep.idDepartamento
				group by dep.nome
					order by dep.nome;
    
/* Relatório 4 - Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado, além da soma do valor 
total das vendas do empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, 
Quantidade Vendas, Total Valor Vendido, Total Comissão das Vendas), ordenado por quantidade total de vendas realizadas; */

select 	UPPER(emp.nome) as "Nome Empregado",
		emp.cpf as "CPF Empregado",
		emp.sexo as "Sexo",
		emp.salario as "Salário",
		COUNT(venda.idVenda) as "Quantidade Vendas",
		SUM(venda.valor) as "Total Valor Vendido",
		SUM(emp.comissao) as "Total Comissão das Vendas"
		from empregado emp
			inner join venda on emp.cpf = venda.Empregado_cpf
				group by emp.cpf
					order by "Quantidade Vendas" desc;

/* Relatório 5 - Lista dos empregados que prestaram Serviço na venda computando a quantidade total de vendas 
realizadas com serviço por cada Empregado, além da soma do valor total apurado pelos serviços prestados nas 
vendas por empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, 
Salário, Quantidade Vendas com Serviço, Total Valor Vendido com Serviço, Total Comissão das Vendas com Serviço),
 ordenado por quantidade total de vendas realizadas; */
 
select	UPPER(emp.nome) as "Nome Empregado",
		emp.cpf as "CPF Empregado",
		emp.sexo as "Sexo",
		emp.salario as "Salário",
		COUNT(vnd.idVenda) as "Quantidade Vendas com Serviço",
		SUM(vnd.valor) as "Total Valor Vendido com Serviço",
		SUM(emp.comissao) as "Total Comissão das Vendas com Serviço"
		from empregado emp
			inner join venda vnd on emp.cpf = vnd.Empregado_cpf
				group by emp.cpf
					order by "Quantidade Vendas com Serviço" desc;

/* Relatório 6 - Lista dos serviços já realizados por um Pet, trazendo as colunas (Nome do Pet, Data do 
Serviço, Nome do Serviço, Quantidade, Valor, Empregado que realizou o Serviço), ordenado por data do 
serviço da mais recente a mais antiga; */


	select pet.nome as " Nome do Pet", vnd.data  as " Data do Serviço", srv.nome as " Nome do Serviço", 
	count(isrv.quantidade) as " Quatidade do Serviço", isrv.valor as " Valor", emp.nome as " Empregado que realizou o serviço"
	from itensservico isrv
		inner join servico srv on srv.idServico = isrv.Servico_idServico
		inner join venda vnd on vnd.idVenda = isrv.Venda_idVenda
		inner join empregado emp on emp.cpf= vnd.Empregado_cpf
		inner join pet pet on pet.idPET = isrv.PET_idPET 
			group by pet.nome, vnd.data, srv.nome, isrv.valor, emp.nome
				order by vnd.data desc; 

/* Relatório 7 - Lista das vendas já realizadas para um Cliente, trazendo as colunas (Data da Venda, Valor, 
desconto, Valor Final, Empregado que realizou a venda), ordenado por data da venda da mais recente a mais 
antiga; */

	select cli.nome as " Cliente", vnd.data as "Data da Venda ", vnd.valor as " Valor", 
	vnd.desconto as "desconto", (vnd.valor - vnd.desconto) as "Valor Final",
		emp.nome as "Empregado que realizou a Venda"
	from venda vnd
		inner join cliente cli on cli.cpf = vnd.Cliente_cpf
		inner join empregado emp on emp.cpf = vnd.Empregado_cpf
			order by vnd.data desc; 



/* Relatório 8 - Lista dos 10 serviços mais vendidos, trazendo a quantidade de vendas de cada serviço, 
o somatório total dos valores de serviço vendido, com as colunas (Nome do Serviço, Quantidade Vendas, 
Total Valor Vendido), ordenado por quantidade total de vendas realizadas; */


	select srv.nome as "Nome do servico", count(isrv.quantidade) as " Quantidade de Vendas ", sum(isrv.valor) as "Total Valor Vendido"
	from  itensservico isrv
		inner join servico srv on srv.idServico = isrv.Servico_idServico
			group by srv.nome
				order by count(isrv.quantidade) desc 
					limit 10; 

/* Relatório 9 - Lista das formas de pagamentos mais utilizadas nas Vendas, informando quantas vendas cada forma de pagamento 
já foi relacionada, trazendo as colunas (Tipo Forma Pagamento, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade
 total de vendas realizadas; */
	
    select fpgv.tipo as " Forma de Pagamento", count(ivprod.quantidade) as "Quantidade de Vendas", sum(ivprod.valor) as "Valor Total Vendido"
	from formapgvenda fpgv    
		inner join venda vnd on vnd.idVenda = fpgv.venda_idVenda 
		inner join itensvendaprod ivprod on ivprod.Venda_idVenda = vnd.idVenda
			group by fpgv.tipo 
				order by count(ivprod.quantidade);
    
/* Relatório 10 - Balaço das Vendas, informando a soma dos valores vendidos por dia, trazendo as colunas (Data Venda, Quantidade de Vendas,
 Valor Total Venda), ordenado por Data Venda da mais recente a mais antiga; */

	select date_format(vnd.data, '%d/%m/%Y') "Data Venda" , count(vnd.idVenda) as " Quantidade de vendas", sum(vnd.valor) as " Valor Total Venda"
	from venda vnd 
		group by date_format(vnd.data, '%d/%m/%Y') 
			order by date_format(vnd.data, '%d/%m/%Y');

/* Relatório 11 - Lista dos Produtos, informando qual Fornecedor de cada produto, trazendo as colunas 
(Nome Produto, Valor Produto, Categoria do Produto, Nome Fornecedor, Email Fornecedor, Telefone Fornecedor), 
ordenado por Nome Produto; */

	
	   select prod.nome as "Nome Produto",
	   prod.valorVenda as "Valor Produto",
	   prod.marca as "Marca", forn.nome as "Nome Fornecedor",
	   forn.email as "Email Fornecedor",
	   tel.numero as "Telefone Fornecedor" 
	   from Produtos prod inner join ItensCompra ic on prod.idProduto = ic.Produtos_idProduto 
		   inner join Compras comp on ic.Compras_idCompra = comp.idCompra 
		   inner join Fornecedor forn on comp.Fornecedor_cpf_cnpj = forn.cpf_cnpj 
		   LEFT JOIN Telefone tel on forn.cpf_cnpj = tel.Fornecedor_cpf_cnpj 
			order by prod.nome;

/* Relatório 12 - Lista dos Produtos mais vendidos, informando a quantidade (total) de vezes que cada produto participou 
em vendas e o total de valor apurado com a venda do produto, trazendo as colunas (Nome Produto, Quantidade (Total) Vendas, 
Valor Total Recebido pela Venda do Produto), ordenado por quantidade de vezes que o produto participou em vendas */

	select prod.nome as "Nome Produto", 
	COUNT(ivprod.Produto_idProduto) as "Quantidade (Total) Vendas", 
	SUM(ivprod.valor) as "Valor Total Recebido pela Venda do Produto" 
	from ItensVendaProd ivprod 
		inner join Produtos prod on ivprod.Produto_idProduto = prod.idProduto 
			group by prod.nome 
				order by COUNT(ivprod.Produto_idProduto) desc;