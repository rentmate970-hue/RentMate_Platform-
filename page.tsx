const experiences = [
  ["Dating & connection", "Meet people with shared interests and intentions."],
  ["Friendship & communities", "Find activity partners and welcoming communities."],
  ["Social companionship", "Book verified companions for lawful, non-sexual public activities."],
];

export default function Home() {
  return <main>
    <nav className="nav"><a className="brand" href="/">RM<span>.</span></a><div><a href="#how">How it works</a><a href="/login">Log in</a><a className="navCta" href="/login">Get started</a></div></nav>
    <section className="hero">
      <p className="eyebrow">A NEW WAY TO CONNECT · 18+</p>
      <h1>Meet. Connect.<br/><em>Experience.</em></h1>
      <p className="lead">Real connections, shared interests and better experiences — all in one trusted community.</p>
      <a className="cta" href="/login">Join RentMate <span>→</span></a>
      <p className="fine">Adults 18+ only · Respectful connections · Safety first</p>
      <div className="orb orb1"/><div className="orb orb2"/>
    </section>
    <section className="section" id="how"><p className="eyebrow">EXPLORE RENTMATE</p><h2>More ways to connect.</h2><div className="cards">{experiences.map(([title,desc],i)=><article className="card" key={title}><span className="number">0{i+1}</span><h3>{title}</h3><p>{desc}</p></article>)}</div></section>
    <footer>© {new Date().getFullYear()} RentMate. Built around trust, consent and safety.</footer>
  </main>;
}
