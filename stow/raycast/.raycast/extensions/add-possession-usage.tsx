#!/usr/bin/env tsx

import { ActionPanel, Form, showToast, Toast } from "@raycast/api";
import { exec } from "child_process";
import { promisify } from "util";

const execAsync = promisify(exec);

export default function Command() {
  async function handleSubmit(values: { amount: string; startDate: string; endDate: string }) {
    const { amount, startDate, endDate } = values;
    const sql = `INSERT INTO possessions_usage (possession_id, type, amount, start_date, end_date) VALUES ('c8744876-2621-4828-900f-985777191ec6', 'pattern', ${amount}, '${startDate}', '${endDate}');`;
    const cmd = `docker exec -i hominem-postgres psql -U postgres -d postgres -c "${sql.replace(/"/g, '\\"')}"`;

    try {
      await execAsync(cmd);
      showToast({ style: Toast.Style.Success, title: "Usage added" });
    } catch (error: any) {
      showToast({ style: Toast.Style.Failure, title: "Failed to add usage", message: error.message });
    }
  }

  return (
    <Form
      actions={
        <ActionPanel>
          <ActionPanel.SubmitForm title="Create record" onSubmit={handleSubmit} />
        </ActionPanel>
      }
    >
      <Form.TextField id="amount" title="Amount" placeholder="e.g. 100" />
      <Form.DatePicker id="startDate" title="Start date" />
      <Form.DatePicker id="endDate" title="End date" />
    </Form>
  );
}
