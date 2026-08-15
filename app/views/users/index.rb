class Views::Users::Index < Views::Base
  FORM_ID = "users_form"

  def initialize(pagy:, users:)
    @pagy = pagy
    @users = users
  end

  def view_template
    section(class: "space-y-2") do
      Heading(level: 3, size: "3", class: "text-muted-foreground") { "Users" }

      DataTable(id: "users_list") do
        DataTableToolbar do
          DataTableSearch(name: "q[first_name_or_last_name_or_email_cont]", path: users_path, frame_id: "users_list", value: params.dig(:q, :first_name_or_last_name_or_email_cont))
          div(class: "flex items-center gap-2") do
            DataTableBulkActions(class: "flex items-center gap-2") do
              Button(type: "submit", form: FORM_ID, formaction: "#", formmethod: "post", variant: :destructive, size: :sm) { "Delete" }
              Button(type: "submit", form: FORM_ID, formaction: "#", formmethod: "post", variant: :outline, size: :sm) { "Export" }
            end
          end
        end

        DataTableForm(id: FORM_ID, action: "") do
          div(class: "rounded-md border") do
            Table do
              TableHeader do
                TableRow do
                  TableHead(class: "w-10") { DataTableSelectAllCheckbox() }
                  TableHead { "Full Name" }
                  TableHead { "Username" }
                  TableHead { "Email" }
                end
              end
              TableBody do
                @users.each do |e|
                  TableRow do
                    TableCell { DataTableRowCheckbox(value: e.id) }
                    TableCell { e.full_name }
                    TableCell { e.username }
                    TableCell { e.email }
                  end
                end
              end
            end
          end
        end

        DataTablePaginationBar do
          DataTableSelectionSummary(total_on_page: @users.size)
          DataTablePagination(pagy: @pagy, path: users_path, frame_id: "users_list")
        end
      end
    end
  end

  private

  attr_reader :pagy, :users
end
