import verik.base.*
import verik.data.*

class Top: Module() {

    var clk = t_Boolean()
    var rst = t_Boolean()

    @make val cache_bus = t_MemBus().with(clk)

    @make val mem_bus = t_MemBus().with(clk)

    @make val cache = t_Cache().with(
        clk   = clk,
        rst   = rst,
        rx_bp = cache_bus.rx_bp,
        tx_bp = mem_bus.tx_bp
    )

    @make val mem = t_Mem().with(
        clk = clk,
        rst = rst,
        bp  = mem_bus.rx_bp
    )

    @make val tb = t_CacheTb().with(
        rst = rst,
        bp  = cache_bus.tb_bp
    )

    @run fun toggle_clk() {
        clk = false
        forever {
            delay(1)
            clk = !clk
        }
    }
}