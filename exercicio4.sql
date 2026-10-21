CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela de log de desativação
CREATE TABLE clientes_deletados_log (
    id SERIAL PRIMARY KEY,
    cliente_id INT,
    nome VARCHAR(100),
    email VARCHAR(100),
    data_remocao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create or replace function fn_soft_delete_cliente()
returns trigger as $$
begin

insert into clientes_deletador_log (cliente_id, nome, email)
values(old.id, old.nome, old.email);

update clientes set ativo = FALSE where id = old.id;

return null;
end;

$$ language plpgsql;

create trigger trg_soft_delete_cliente
before delete on clientes
for each row
execute function fn_soft_delete_cliente();