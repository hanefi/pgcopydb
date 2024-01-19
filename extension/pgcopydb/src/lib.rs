use pgrx::prelude::*;

use std::{
    io::{BufRead, BufReader},
    process::{Command, Stdio},
};

pgrx::pg_module_magic!();

#[pg_extern]
fn pgcopydb(args: Vec<String>) -> String {
    let mut child = Command::new("pgcopydb")
        .args(args)
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
		.expect("failed to spawn pgcopydb process");

    let stderr = child.stderr.take().unwrap();
    let stderr_reader = BufReader::new(stderr);

	for line in stderr_reader.lines() {
        let line = line.expect("Failed to read line from stderr");
        log!("[pgcopydb cli]: {}", line);
    }


    let output = child.wait_with_output().expect("Failed to wait on pgcopydb process");
	let stdout_str = String::from_utf8_lossy(&output.stdout).to_string();

    if !output.status.success() {
        panic!(
            "pgcopydb command failed: stdout: {}",
            stdout_str
        );
    }

    stdout_str
}

#[pg_extern]
fn pgcopydb_help() -> String {
    pgcopydb(vec!["help".to_string()])
}

#[pg_extern]
fn pgcopydb_clone(
    source: Option<String>,
    target: Option<String>,
    other_args: Vec<String>,
) -> String {
    let mut args = vec!["clone".to_string()];

    if let Some(source) = source {
        args.push("--source".to_string());
        args.push(source);
    }

    if let Some(target) = target {
        args.push("--target".to_string());
        args.push(target);
    }

    args.extend(other_args);

    pgcopydb(args)
}

#[pg_extern]
fn pgcopydb_list_progress(source: Option<String>) -> String {
    let mut args: Vec<String> = vec![];
    args.push("list".to_string());
    args.push("progress".to_string());

    if let Some(source) = source {
        args.push("--source".to_string());
        args.push(source);
    }

    args.push("--json".to_string());
    args.push("--summary".to_string());

    pgcopydb(args)
}
