create table reservas(
	id serial primary key,
	numero_quarto int not null,
	data_checkin date not null,
	data_checkout date not null,
	valor_diaria numeric(10,2) not null,
	valor_total numeric(10,2)
);

create or replace function fn_processa_reserva()
returns trigger as $$
declare dias_estadia int;
begin

	if new.data_checkout <= new.data_checkin then
	raise exception 'A data de check-out (%) precisa ser posterior à data de check-in (%)!',
	new.data_checkout, new.data_checkin;
	end if;

	dias_estadia := new.data_checkout - new.data_checkin;
	new.valor_total := new.valor_diaria * dias_estadia;

	return new;
end;
$$ language plpgsql;

create trigger trg_trigger_ex5
before insert or update on reservas
for each row
execute function fn_processa_reserva();