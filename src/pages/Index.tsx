import { useEffect } from "react";
import { Button } from "@/components/ui/button";

const Index = () => {
  useEffect(() => {
    document.title = "UVM верификация UART — проект";
    const desc = "Полный UVM тестбенч для UART: агент, драйвер, монитор, scoreboard, coverage и тесты.";
    const setMeta = (name: string, content: string) => {
      let tag = document.querySelector(`meta[name="${name}"]`);
      if (!tag) {
        tag = document.createElement("meta");
        tag.setAttribute("name", name);
        document.head.appendChild(tag);
      }
      tag.setAttribute("content", content);
    };
    setMeta("description", desc);

    let canonical = document.querySelector('link[rel="canonical"]');
    if (!canonical) {
      canonical = document.createElement("link");
      canonical.setAttribute("rel", "canonical");
      document.head.appendChild(canonical);
    }
    canonical.setAttribute("href", "/");
  }, []);

  return (
    <div className="min-h-screen hero-bg">
      <header className="w-full">
        <nav className="mx-auto max-w-6xl px-6 py-6 flex items-center justify-between">
          <span className="text-sm font-semibold tracking-wide text-muted-foreground">UVM • UART</span>
          <a href="#run" className="text-sm text-muted-foreground hover:text-foreground transition-colors">Запуск</a>
        </nav>
      </header>

      <main>
        <section className="mx-auto max-w-6xl px-6 pt-10 pb-16">
          <div className="max-w-3xl">
            <h1 className="text-4xl sm:text-5xl font-bold leading-tight mb-4">UVM верификация UART</h1>
            <p className="text-lg text-muted-foreground mb-8">
              Готовый к использованию проект UVM для проверки UART: поддержка различных скоростей,
              формата кадра, паритета, сбор покрытия и сравнение ожидаемых/наблюдаемых данных.
            </p>
            <div className="flex flex-wrap gap-4">
              <a href="#structure"><Button size="lg" variant="hero">Структура проекта</Button></a>
              <a href="#run"><Button size="lg" variant="outline">Как запустить</Button></a>
            </div>
          </div>
        </section>

        <section id="features" className="mx-auto max-w-6xl px-6 pb-4 grid gap-6 md:grid-cols-3">
          <article className="glass rounded-lg p-6 shadow-glow">
            <h2 className="text-xl font-semibold mb-2">Полный агент UART</h2>
            <p className="text-sm text-muted-foreground">Driver, Sequencer, Monitor с виртуальным интерфейсом и конфигурацией.</p>
          </article>
          <article className="glass rounded-lg p-6 shadow-glow">
            <h2 className="text-xl font-semibold mb-2">Scoreboard и Coverage</h2>
            <p className="text-sm text-muted-foreground">Сравнение ожидаемых/фактических данных и функциональное покрытие кадров.</p>
          </article>
          <article className="glass rounded-lg p-6 shadow-glow">
            <h2 className="text-xl font-semibold mb-2">Тесты и последовательности</h2>
            <p className="text-sm text-muted-foreground">Smoke/Random тесты, базовые и ошибочные последовательности.</p>
          </article>
        </section>

        <section id="structure" className="mx-auto max-w-6xl px-6 py-12">
          <h2 className="text-2xl font-bold mb-4">Структура файлов</h2>
          <pre className="glass rounded-lg p-6 overflow-auto text-sm leading-6">
{`uvm/
  ├─ dut/
  │   └─ dut_uart.sv            // простая заглушка DUT (tx = rx)
  ├─ uart_if.sv                 // интерфейс + clocking/modports
  ├─ uart_seq_item.sv           // транзакция UART
  ├─ uart_sequencer.sv
  ├─ uart_driver.sv
  ├─ uart_monitor.sv
  ├─ uart_agent.sv
  ├─ uart_scoreboard.sv
  ├─ uart_coverage.sv
  ├─ uart_env.sv
  ├─ sequences/
  │   ├─ basic_seq.sv
  │   └─ error_seq.sv
  ├─ tests/
  │   ├─ base_test.sv
  │   ├─ smoke_test.sv
  │   └─ random_test.sv
  └─ top_tb.sv                  // точка входа (run_test)
`}
          </pre>
        </section>

        <section id="run" className="mx-auto max-w-6xl px-6 py-12">
          <h2 className="text-2xl font-bold mb-4">Как запустить симуляцию</h2>
          <div className="grid gap-6 md:grid-cols-2">
            <article className="glass rounded-lg p-6">
              <h3 className="font-semibold mb-2">Questa/ModelSim</h3>
              <pre className="text-sm overflow-auto">{`vlib work
vlog +acc +cover=bcfst -sv uvm/*.sv uvm/sequences/*.sv uvm/tests/*.sv
vsim -c -do "run -all; quit" work.top_tb +UVM_TESTNAME=smoke_test`}</pre>
            </article>
            <article className="glass rounded-lg p-6">
              <h3 className="font-semibold mb-2">Synopsys VCS</h3>
              <pre className="text-sm overflow-auto">{`vcs -sverilog -full64 -debug_access+pp +vpi +vcs+lic+wait \
  uvm/*.sv uvm/sequences/*.sv uvm/tests/*.sv \
  -l comp.log -o simv
./simv +UVM_TESTNAME=random_test -l run.log`}</pre>
            </article>
          </div>
        </section>
      </main>

      <footer className="mx-auto max-w-6xl px-6 py-10 text-sm text-muted-foreground">
        © UVM UART TB. Документация внутри исходников.
      </footer>
    </div>
  );
};

export default Index;
