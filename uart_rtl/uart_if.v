interface uart_if;
        logic tx;
        logic rx;
        logic baud_o;
        bit IRQ;

//drv_cb - op - tx. ip - baud_o

//mon_cb - ip- tx, rx, baud_o
endinterface
