# Portfólio — modelos, cursos e mentoria

Site estático, três abas: **Modelos desenvolvidos**, **Cursos** e **Mentoria**.
Hospedagem no GitHub Pages, sem custo e sem domínio próprio.

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

## Passo 4 — Ativar o questionário da mentoria

Nome, GitHub e LinkedIn já estão preenchidos. **Só falta este passo**, e ele é uma
linha só.

O questionário já está montado dentro do `index.html` — com o visual do site, não
num iframe de fora. O que falta é dizer para onde as respostas vão. Site estático não
recebe envio de formulário, então usamos um serviço que faz esse repasse. O
[Web3Forms](https://web3forms.com) é grátis até 250 respostas por mês e **não exige
criar conta**: você informa o e-mail e ele te manda uma chave.

1. Entre em [web3forms.com](https://web3forms.com), digite seu e-mail e clique em
   criar a chave de acesso.
2. Confira a caixa de entrada — a chave chega por e-mail. É um código longo, tipo
   `a1b2c3d4-5e6f-7890-abcd-ef1234567890`.
3. Em `index.html`, procure por:

```html
<input type="hidden" name="access_key" value="COLE-AQUI-SUA-ACCESS-KEY">
```

4. Troque `COLE-AQUI-SUA-ACCESS-KEY` pela chave. Pronto — cada inscrição cai direto
   no seu e-mail, com todos os campos preenchidos.

**Enquanto a chave não estiver lá, o formulário aparece bonito mas não envia nada.**
Faça um envio de teste depois de trocar.

Seu e-mail não fica exposto no código do site — quem inspecionar a página vê só a
chave, e a chave sozinha não serve para receber nada.

### Se preferir um painel em vez de e-mail

Se quiser ver as respostas em tabela e exportar, use [tally.so](https://tally.so)
(grátis, respostas ilimitadas): monte o formulário lá, pegue o `<iframe>` em
**Share → Embed**, e substitua todo o bloco `<form class="form">...</form>` por ele.
Você perde o visual integrado, mas ganha o painel. As perguntas para recriar no Tally
são exatamente as que estão no `index.html`.

---

## Estrutura

```
index.html                     o site (as três abas)
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
  relatorio_score_apostador.html
  Score_Apostador.ipynb
  Scorecard_Apostador.xlsx
  relatorio_cluster_bets.html
  Cluster_Bets.ipynb
  Regua_Clusterizacao_Bets.xlsx
```

Total: ~12 MB. Os limites do GitHub Pages são 1 GB de site e 100 GB de tráfego por mês,
então há folga de sobra para crescer.

---

## Onde o link entra no LinkedIn

1. **Destaques** — o card principal, logo abaixo do "Sobre". É de onde vem quase todo o clique.
2. **Informações de contato → Site** — até 3 endereços; use um slot para o site.
3. **Projetos** — uma entrada por estudo, com o link direto da aba.

As abas têm endereço próprio, então o post pode mandar a pessoa direto ao ponto:

```
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
