import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'Sobre o Jogo',
    Svg: require('@site/static/img/undraw_docusaurus_mountain.svg').default,
    description: (
      <>
        The Last of Us é um jogo de ação-aventura e survival horror desenvolvido pela Naughty Dog. O jogo é ambientado em um mundo pós-apocalíptico devastado por uma pandemia causada por um fungo que transforma os humanos em criaturas agressivas.
      </>
    ),
  },
  {
    title: 'Jogabilidade',
    Svg: require('@site/static/img/undraw_docusaurus_tree.svg').default,
    description: (
      <>
        A história segue Joel, um sobrevivente endurecido, e Ellie, uma jovem imune ao fungo, enquanto viajam pelos Estados Unidos em busca de uma possível cura.
      </>
    ),
  },
  {
    title: 'MUD',
    Svg: require('@site/static/img/undraw_docusaurus_react.svg').default,
    description: (
      <>
        MUD (Multi-User Dungeon) é um tipo de jogo online de role-playing que surgiu nos anos 1970. Esses jogos são baseados em texto e permitem que múltiplos jogadores interajam uns com os outros em um mundo virtual descrito por texto.
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
