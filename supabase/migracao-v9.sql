-- =====================================================================
-- Migração v9 — permissões explícitas das tabelas
-- Projetos novos do Supabase não liberam as tabelas automaticamente para o app
-- (erro "permission denied for table ..."). Este bloco dá as permissões de forma explícita.
-- Quem pode ver o quê continua sendo decidido pelas regras (RLS) do schema.sql.
-- Pode rodar quantas vezes quiser.
-- =====================================================================

grant usage on schema public to authenticated, service_role;

grant select, insert, update, delete on
  public.trainer_allowlist, public.trainers, public.exercises, public.students, public.plans,
  public.workout_logs, public.templates, public.assessments, public.anamnesis,
  public.push_subs, public.notif_prefs, public.charges, public.sessions
  to authenticated;

grant all on
  public.trainer_allowlist, public.trainers, public.exercises, public.students, public.plans,
  public.workout_logs, public.templates, public.assessments, public.anamnesis,
  public.push_subs, public.notif_prefs, public.charges, public.sessions
  to service_role;

-- Colunas que o app pode alterar (o resto fica protegido)
revoke insert, update on public.students from authenticated;
grant insert (name, goal, notes) on public.students to authenticated;
grant update (name, goal, notes, features, fee, due_day) on public.students to authenticated;

revoke update on public.workout_logs from authenticated;
grant update (trainer_seen, trainer_reply, replied_at) on public.workout_logs to authenticated;

revoke update on public.notif_prefs from authenticated;
grant update (user_id, notify_logs, notify_replies, notify_plans, remind_days, remind_time, tz) on public.notif_prefs to authenticated;

-- Visitantes sem login não acessam nenhuma tabela
revoke all on
  public.trainer_allowlist, public.trainers, public.exercises, public.students, public.plans,
  public.workout_logs, public.templates, public.assessments, public.anamnesis,
  public.push_subs, public.notif_prefs, public.charges, public.sessions
  from anon;
