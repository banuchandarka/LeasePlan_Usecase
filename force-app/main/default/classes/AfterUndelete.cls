/**
 * @author: Banuchandar
 * @date: 11/05/2023
 */

public interface AfterUndelete {
    void handleAfterUndelete(List<sObject> newList);
}