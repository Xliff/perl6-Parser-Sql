v6.c;

use Test;

use Parser::SQL::Grammar::DDLGrammar;

for Parser::SQL::Grammar::DDLGrammar.^methods(:local).map( *.name ).sort {
  when <
    _con_function_call
    _gen_function_call
    _join_table
    _key_function_call
    _nonkey_function_call
    _when_clause
    attribute
    bit_expr
    bool_pri
    check_constraint
    col_def
    create_select
    create_table_opt
    create_table_opts
    escape
    expr
    expr_list
    field_def
    field_spec
    having_clause
    key_def
    literal
    part_type_def
    predicate
    query_spec
    row_types
    select_item
    select_item_list
    select_paren_derived
    select_part2
    select_part2_derived
    simple_expr
    sum_expr
    table_expression
    table_ref
    type
    udf_expr
    variable
  >.any {
    pass 'Evaluated in a separate test.';
  }

  when '_cast_type' {
  }

  when '_gorder_clause' {
  }

  when '__ws_list_item' {
  }

  when '__ws_nweights' {
  }

  when '__ws_levels' {
  }

  when '_into' {
  }

  when 'all_key_opt' {
  }

  when 'alter_algo_option' {
  }

  when 'alter_lock_option' {
  }

  when 'charset' {
  }

  when 'charset_name_or_default' {
  }

  when 'collate_explicit' {
  }

  when 'constraint_key_type' {
  }

  when 'constraint' {
  }

  when 'create_field_list' {
  }

  when 'derived_table_list' {
  }

  when 'field_list_item' {
  }

  when 'field_term' {
  }

  when 'from_clause' {
  }

  when 'gcol_attr' {
  }

  # Considfer moving to tokens as a rule.
  when 'generated_always' {
  }

  when 'index_lock_algo' {
  }

  when 'if_not_exists' {
  }

  when 'limit_clause' {
  }

  when 'line_term' {
  }

  when 'load_data_charset' {
  }

  when 'lock_expire_opts' {
  }

  when 'now' {
  }

  when 'order_expr' {
  }

  when 'part_field_list' {
  }

  when 'procedure_analyse_clause' {
  }

  when 'select_lock_type' {
  }

  when 'select_option' {
  }

  when 'simple_ident_nospvar' {
  }

  when 'table_alias' {
  }

  when 'table_list' {
  }

  when 'table_wild' {
  }

  when 'row_types' {
  }

  when 'use_partition' {
  }

  when 'using_list' {
  }

  # Connect Opts in DDLGrammar

}
