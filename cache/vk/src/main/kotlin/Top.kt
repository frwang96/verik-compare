import verik.base.*
import verik.data.*

class Top: Module() {

    var clk = t_Boolean()

    @make val cache_bus = t_MemBus().with(clk)

    @make val mem_bus = t_MemBus().with(clk)

    @make val cache = t_Cache().with(clk, cache_bus.rx_bp, mem_bus.tx_bp)

    @make val mem = t_Mem().with(clk, mem_bus.rx_bp)

    @make val tb = t_CacheTb().with(cache_bus.tb_bp)

    @run fun toggle_clk() {
        clk = false
        forever {
            delay(1)
            clk = !clk
        }
    }
}