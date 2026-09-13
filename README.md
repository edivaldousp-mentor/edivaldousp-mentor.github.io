# Portfólio — modelos, cursos e mentoria

Site estático, quatro abas: **Sobre mim**, **Modelos desenvolvidos**, **Cursos** e
**Mentoria**. Hospedagem no GitHub Pages, sem custo e sem domínio próprio.

Esta versão substitui a anterior por completo: sobe tudo por cima, é para isso que o
pacote vem inteiro.

---

## Passo 1 — Criar o repositório

No GitHub, crie um repositório **público** com o nome exato:

```
edivaldousp-mentor.github.io
```

Esse nome exato — seu usuário seguido de `.github.io` — é o que faz o site sair no
endereço raiz `https://edivaldousp-mentor.github.io`, sem `/pasta` no fim.
Com qualquer outro nome o site funciona igual, mas o endereço vira
`https://edivaldousp-mentor.github.io/nome-do-repo/`, que é pior de divulgar.

## Passo 2 — Subir os arquivos

Pelo navegador (mais simples): **Add file → Upload files**, arraste a pasta inteira, commit.

Pelo terminal:

```bash
cd site
git init
git add .
git commit -m "Portfólio: modelos, cursos e mentoria"
git branch -M main
git remote add origin https://github.com/edivaldousp-mentor/edivaldousp-mentor.github.io.git
git push -u origin main
```

## Passo 3 — Ligar o GitHub Pages

No repositório: **Settings → Pages → Build and deployment → Source: Deploy from a branch**,
branch `main`, pasta `/ (root)`, **Save**. Em 1 a 2 minutos o site está no ar.

O arquivo `.nojekyll` já está incluído — ele impede que o GitHub tente processar a
pasta como um blog e ignore arquivos. Não apague.

---

## Passo 4 — O questionário da mentoria já está ligado

A chave do [Web3Forms](https://web3forms.com) já está no `index.html`, então cada
inscrição cai direto no seu e-mail com todos os campos preenchidos. **Faça um envio de
teste depois de publicar**, só para ver a mensagem chegar.

A chave fica visível para quem abrir o código-fonte da página, e é assim que o serviço
funciona: ela diz para onde mandar, não dá acesso a nada seu. Se um dia começar a chegar
spam, gere outra chave no site e troque esta linha:

```html
<input type="hidden" name="access_key" value="...">
```

O plano gratuito cobre 250 respostas por mês.

### Se preferir um painel em vez de e-mail

Se quiser ver as respostas em tabela e exportar, use [tally.so](https://tally.so)
(grátis, respostas ilimitadas): monte o formulário lá, pegue o `<iframe>` em
**Share → Embed**, e substitua todo o bloco `<form class="form">...</form>` por ele.
Você perde o visual integrado, mas ganha o painel. As perguntas para recriar no Tally
são exatamente as que estão no `index.html`.

---

## Estrutura

```
index.html                     o site (as quatro abas)
.nojekyll                      não apagar
cursos/
  Base_Vendas_Exploracao.xlsx  base de prática dos três cursos
  curso_sql.html               curso Excel → SQL
  vendas.db                    banco SQLite do curso de SQL
  Curso_SQL_consultas.sql      as 39 consultas
  curso_python.html            curso SQL → Python
  Curso_Python_Analise_de_Dados.ipynb
  curso_powerbi.html           curso Excel/SQL → Power BI
  Modelo_PowerBI.xlsx          modelo estrela para importar
  Curso_PowerBI_codigo.txt     17 medidas DAX + 2 blocos M
modelos/
  relatorio_score_apostador.html      01 · score de propensão a apostar
  Score_Apostador.ipynb
  Scorecard_Apostador.xlsx
  relatorio_cluster_bets.html         02 · clusterização de risco em apostas
  Cluster_Bets.ipynb
  Regua_Clusterizacao_Bets.xlsx
  relatorio_restritivos_gs.html       03 · grau de severidade de restritivos
  GS_Restritivos.ipynb
  Grau_Severidade_Restritivos.xlsx
  relatorio_previsao_volume.html      04 · previsão de volume
  Previsao_Volume.ipynb
  Planejamento_Producao.xlsx
  relatorio_renda.html                05 · estimação de renda (só o relatório)
```

Total: ~24 MB. Os limites do GitHub Pages são 1 GB de site e 100 GB de tráfego por mês,
então há folga de sobra para crescer.

---

## Onde o link entra no LinkedIn

1. **Destaques** — o card principal, logo abaixo do "Sobre". É de onde vem quase todo o clique.
2. **Informações de contato → Site** — até 3 endereços; use um slot para o site.
3. **Projetos** — uma entrada por estudo, com o link direto da aba.

As abas têm endereço próprio, então o post pode mandar a pessoa direto ao ponto:

```
https://edivaldousp-mentor.github.io/#sobre
https://edivaldousp-mentor.github.io/#modelos
https://edivaldousp-mentor.github.io/#cursos
https://edivaldousp-mentor.github.io/#mentoria
```

---

## Depois, se quiser domínio próprio

Registre em [registro.br](https://registro.br) (`.com.br` custa cerca de R$40/ano),
aponte o DNS para o GitHub e informe o domínio em **Settings → Pages → Custom domain**.
Os endereços antigos continuam funcionando por redirecionamento — nada quebra.

---

## Sobre os dados

Todas as bases deste repositório são **sintéticas**, geradas por script. Não há dado de
cliente, de instituição ou de terceiros em nenhum arquivo. Antes de publicar depoimento
de aluno com nome, foto ou empresa, tenha autorização por escrito — é exigência da LGPD
e o risco é seu, não da plataforma.
